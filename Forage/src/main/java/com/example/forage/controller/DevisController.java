package com.example.forage.controller;

import com.example.forage.model.*;
import com.example.forage.repository.*;
import com.example.forage.service.DevisService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.time.LocalDate;

@Controller
@RequestMapping("/devis")
public class DevisController {

    @Autowired
    private DevisRepository devisRepository;

    @Autowired
    private TypeDevisRepository typeDevisRepository;

    @Autowired
    private DemandeRepository demandeRepository;

    @Autowired
    private DevisService devisService;

    @Autowired
    private DetailsDevisRepository detailsDevisRepository;

    @GetMapping
    public String listDevis(Model model) {
        List<Devis> list = devisRepository.findAll();
        for (Devis devis : list) {
            devis.setMontantCalculé(devisService.calculateTotalAmount(devis.getId()));
        }
        model.addAttribute("devisList", list);
        model.addAttribute("types", typeDevisRepository.findAll());
        model.addAttribute("demandes", demandeRepository.findAll());
        return "devis";
    }

    @PostMapping("/save")
    public String saveDevis(
            @RequestParam(value = "id", required = false) Long id,
            @RequestParam("demandeId") Long demandeId,
            @RequestParam("typeDevisId") Long typeDevisId,
            @RequestParam(value = "dateDevis", required = false) String dateDevisStr,
            @RequestParam(value = "libelles", required = false) List<String> libelles,
            @RequestParam(value = "prixUnitaire", required = false) List<Double> prixUnitaires,
            @RequestParam(value = "quantite", required = false) List<Double> quantites,
            RedirectAttributes redirectAttributes
    ) {
        // Validation des valeurs négatives
        if (prixUnitaires != null) {
            for (Double p : prixUnitaires) {
                if (p != null && p < 0) {
                    redirectAttributes.addFlashAttribute("errorMessage", "Le prix unitaire ne peut pas être négatif.");
                    return "redirect:/devis";
                }
            }
        }
        if (quantites != null) {
            for (Double q : quantites) {
                if (q != null && q < 0) {
                    redirectAttributes.addFlashAttribute("errorMessage", "La quantité ne peut pas être négative.");
                    return "redirect:/devis";
                }
            }
        }

        Devis devis = (id != null) ? devisRepository.findById(id).orElse(new Devis()) : new Devis();
        devis.setDemande(demandeRepository.findById(demandeId).orElse(null));
        devis.setTypeDevis(typeDevisRepository.findById(typeDevisId).orElse(null));
        devis.setDateDevis(dateDevisStr == null || dateDevisStr.isEmpty() ? LocalDate.now() : LocalDate.parse(dateDevisStr));
        
        List<DetailsDevis> details = new ArrayList<>();
        if (libelles != null && prixUnitaires != null && quantites != null) {
            for (int i = 0; i < libelles.size(); i++) {
                if (i < prixUnitaires.size() && i < quantites.size()) {
                    String lib = libelles.get(i);
                    if (lib != null && !lib.trim().isEmpty()) {
                        DetailsDevis d = new DetailsDevis();
                        d.setLibelle(lib);
                        d.setPrixUnitaire(prixUnitaires.get(i));
                        d.setQuantite(quantites.get(i));
                        details.add(d);
                    }
                }
            }
        }
        
        devisService.saveDevis(devis, details);
        return "redirect:/devis";
    }

    @GetMapping("/delete/{id}")
    public String deleteDevis(@PathVariable Long id) {
        devisRepository.deleteById(id);
        return "redirect:/devis";
    }

    @GetMapping("/details/{id}")
    public String viewDevisDetails(@PathVariable Long id, Model model) {
        Optional<Devis> devisOpt = devisRepository.findById(id);
        if (devisOpt.isPresent()) {
            model.addAttribute("devis", devisOpt.get());
            model.addAttribute("details", detailsDevisRepository.findByDevisId(id));
            model.addAttribute("total", devisService.calculateTotalAmount(id));
            return "devis_detail";
        }
        return "redirect:/devis";
    }

    @GetMapping("/stats")
    public String viewStats(Model model) {
        model.addAttribute("ca_previsionnel", devisService.calculateGlobalRevenue());
        return "chiffre_affaire";
    }
}
