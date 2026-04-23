package com.example.forage.controller;

import com.example.forage.model.*;
import com.example.forage.repository.*;
import com.example.forage.service.DemandeService;
import com.example.forage.service.DevisService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.time.LocalDate;
import java.util.*;

@Controller
public class DashboardController {

    @Autowired
    private ClientRepository clientRepository;

    @Autowired
    private DemandeRepository demandeRepository;

    @Autowired
    private DemandeService demandeService;
    
    @Autowired
    private DevisService devisService;
    
    @Autowired
    private DevisRepository devisRepository;
    
    @Autowired
    private DistrictRepository districtRepository;
    
    @Autowired
    private LieuRepository lieuRepository;

    @Autowired
    private StatutRepository statutRepository;

    @Autowired
    private StatusDemandeRepository statusDemandeRepository;

    @GetMapping("/")
    public String dashboard(Model model) {
        List<Client> clients = clientRepository.findAll();
        model.addAttribute("clients", clients);
        model.addAttribute("districts", districtRepository.findAll());
        model.addAttribute("lieus", lieuRepository.findAll());
        
        List<Demande> demandes = demandeRepository.findAll();
        Map<Long, StatusDemande> currentStatusEntries = new HashMap<>();
        Map<String, Integer> statusDistribution = new HashMap<>();
        
        for (Demande d : demandes) {
            StatusDemande latest = statusDemandeRepository.findByDemandeIdOrderByDateStatutDesc(d.getId())
                    .stream().findFirst().orElse(null);
            currentStatusEntries.put(d.getId(), latest);
            String statusName = latest != null ? latest.getStatut().getNomStatut() : "Inconnu";
            statusDistribution.put(statusName, statusDistribution.getOrDefault(statusName, 0) + 1);
        }
        
        model.addAttribute("demandes", demandes);
        model.addAttribute("statusEntries", currentStatusEntries);
        model.addAttribute("statusDistribution", statusDistribution);
        model.addAttribute("totalRawRevenue", devisService.calculateTotalRawRevenue());
        model.addAttribute("totalForecastedRevenue", devisService.calculateTotalForecastedRevenue());
        model.addAttribute("clientCount", clients.size());
        
        model.addAttribute("newClient", new Client());
        
        Demande d = new Demande();
        d.setClient(new Client());
        d.setLieu(new Lieu());
        model.addAttribute("newDemande", d);
        
        return "dashboard";
    }

    @PostMapping("/client/save")
    public String saveClient(@ModelAttribute Client client) {
        clientRepository.save(client);
        return "redirect:/";
    }

    @GetMapping("/client/delete/{id}")
    public String deleteClient(@PathVariable Long id) {
        clientRepository.deleteById(id);
        return "redirect:/";
    }

    @PostMapping("/demande/save")
    public String saveDemande(
            @RequestParam("clientId") Long clientId,
            @RequestParam("lieuId") Long lieuId,
            @RequestParam(value = "dateDemande", required = false) String dateStr,
            Model model) {
        try {
            Demande demande = new Demande();
            demande.setClient(clientRepository.findById(clientId).orElseThrow(() -> new RuntimeException("Client non trouvé")));
            demande.setLieu(lieuRepository.findById(lieuId).orElseThrow(() -> new RuntimeException("Lieu non trouvé")));
            
            if (dateStr == null || dateStr.isEmpty()) {
                demande.setDateDemande(LocalDate.now());
            } else {
                demande.setDateDemande(LocalDate.parse(dateStr));
            }
            
            demandeService.createDemandeWithInitialStatus(demande);
            return "redirect:/";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/?error=" + e.getMessage();
        }
    }

    @GetMapping("/demande/delete/{id}")
    public String deleteDemande(@PathVariable Long id) {
        demandeRepository.deleteById(id);
        return "redirect:/";
    }

    @GetMapping("/client/details/{id}")
    public String clientDetails(@PathVariable Long id, Model model) {
        Client client = clientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Client non trouvé"));
        
        List<Demande> clientDemandes = demandeRepository.findByClientIdOrderByDateDemandeDesc(id);
        Map<Long, StatusDemande> currentStatusEntries = new HashMap<>();
        for (Demande d : clientDemandes) {
            StatusDemande latest = statusDemandeRepository.findByDemandeIdOrderByDateStatutDesc(d.getId())
                    .stream().findFirst().orElse(null);
            currentStatusEntries.put(d.getId(), latest);
        }
        
        // Récupérer les devis associés au client
        List<Devis> clientDevis = devisRepository.findByDemandeClientIdOrderByDateDevisDesc(id);
        
        model.addAttribute("client", client);
        model.addAttribute("demandes", clientDemandes);
        model.addAttribute("statusEntries", currentStatusEntries);
        model.addAttribute("devis", clientDevis);
        
        return "client_details";
    }

    @GetMapping("/status/change")
    public String changeStatusPage(@RequestParam(value = "demandeId", required = false) Long demandeId,
                                   Model model) {
        List<Demande> demandes = demandeRepository.findAll();
        Map<Long, String> currentStatuses = new HashMap<>();
        Map<Long, StatusDemande> latestStatusEntries = new HashMap<>();

        for (Demande d : demandes) {
            StatusDemande latest = statusDemandeRepository.findByDemandeIdOrderByDateStatutDesc(d.getId())
                    .stream().findFirst().orElse(null);
            latestStatusEntries.put(d.getId(), latest);
            currentStatuses.put(d.getId(), latest != null ? latest.getStatut().getNomStatut() : "Inconnu");
        }

        model.addAttribute("demandes", demandes);
        model.addAttribute("statuts", statutRepository.findAll());
        model.addAttribute("currentStatuses", currentStatuses);
        model.addAttribute("latestStatusEntries", latestStatusEntries);
        model.addAttribute("selectedDemandeId", demandeId);

        if (demandeId != null) {
            List<StatusDemande> history = statusDemandeRepository.findByDemandeIdOrderByDateStatutDesc(demandeId);
            model.addAttribute("statusHistory", history);
        }
        return "status_change";
    }

    @PostMapping("/status/change")
    public String changeStatus(@RequestParam Long demandeId,
                               @RequestParam Long statutId,
                               @RequestParam(required = false) String observation,
                               RedirectAttributes redirectAttributes) {
        try {
            demandeService.addStatusToDemande(demandeId, statutId, observation);
            redirectAttributes.addFlashAttribute("successMessage", "Statut mis à jour avec succès.");
            return "redirect:/status/change?demandeId=" + demandeId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/status/change?demandeId=" + demandeId;
        }
    }
}
