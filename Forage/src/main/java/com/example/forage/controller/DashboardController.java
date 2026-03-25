package com.example.forage.controller;

import com.example.forage.model.Client;
import com.example.forage.model.Demande;
import com.example.forage.repository.ClientRepository;
import com.example.forage.repository.DemandeRepository;
import com.example.forage.service.DemandeService;
import com.example.forage.repository.DemandeStatutRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
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
    private DemandeStatutRepository demandeStatutRepository;

    @GetMapping("/")
    public String dashboard(Model model) {
        model.addAttribute("clients", clientRepository.findAll());
        
        // On récupère toutes les demandes
        List<Demande> demandes = demandeRepository.findAll();
        // On récupère tous les statuts actuels (le dernier pour chaque demande)
        Map<Long, String> currentStatuses = new HashMap<>();
        for (Demande d : demandes) {
            String status = demandeStatutRepository.findAll().stream()
                .filter(ds -> ds.getDemande().getId().equals(d.getId()))
                .sorted((a, b) -> b.getDateStatut().compareTo(a.getDateStatut()))
                .findFirst()
                .map(ds -> ds.getStatus().getLibelle())
                .orElse("Inconnu");
            currentStatuses.put(d.getId(), status);
        }
        
        model.addAttribute("demandes", demandes);
        model.addAttribute("statuses", currentStatuses);
        model.addAttribute("newClient", new Client());
        
        Demande d = new Demande();
        d.setClient(new Client());
        model.addAttribute("newDemande", d);
        
        return "dashboard";
    }

    @PostMapping("/client/save")
    public String saveClient(@ModelAttribute Client client) {
        clientRepository.save(client);
        return "redirect:/";
    }

    @PostMapping("/client/delete/{id}")
    public String deleteClient(@PathVariable Long id) {
        clientRepository.deleteById(id);
        return "redirect:/";
    }

    @PostMapping("/demande/save")
    public String saveDemande(@ModelAttribute Demande demande) {
        if (demande.getDateDemande() == null) {
            demande.setDateDemande(LocalDate.now());
        }
        // Utiliser le service pour une création transactionnelle avec statut initial
        demandeService.createDemandeWithInitialStatus(demande);
        return "redirect:/";
    }

    @PostMapping("/demande/delete/{id}")
    public String deleteDemande(@PathVariable Long id) {
        demandeRepository.deleteById(id);
        return "redirect:/";
    }
}
