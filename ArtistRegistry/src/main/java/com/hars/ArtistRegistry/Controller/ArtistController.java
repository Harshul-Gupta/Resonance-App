package com.hars.ArtistRegistry.Controller;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.security.web.WebAttributes;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hars.ArtistRegistry.Repository.Artist;
import com.hars.ArtistRegistry.Repository.ArtistRepo;
import com.hars.ArtistRegistry.Repository.SearchRepo;
import com.hars.ArtistRegistry.Repository.ArtistSlice;
import com.hars.ArtistRegistry.Service.ArtistService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class ArtistController {

    @Autowired
    ArtistRepo artistRepo;

    @Autowired
    MongoTemplate mongoTemplate;

    @Autowired
    ArtistService artistService;
    
    @Autowired
    SearchRepo sRepo;
    
    @ModelAttribute("genres")
    public List<String> populateGenres() {
        return Arrays.asList("Pop", "Jazz", "Classical", "Hip-Hop", "Electronic", "Rock", "R&B");
    }
    
    @GetMapping("/")
    public String indexPage(Model model) {
        model.addAttribute("stats", buildStats());
        return "index"; // resolves to /WEB-INF/views/index.jsp
    }
    
// First simple implementation of Search    
    
//    @GetMapping("/search")
//    public String searchPage(
//            @RequestParam(value = "name",  required = false, defaultValue = "") String name,
//            @RequestParam(value = "genre", required = false, defaultValue = "") String genre,
//            Model model) {
//
//        List<Artist> results;
//
//        if (!name.isBlank()) {
//            if (!genre.isBlank()) {
//                results = artistRepo.findByNameContainingIgnoreCaseAndGenreContaining(name, genre);
//            } else {
//                results = artistRepo.findByNameContainingIgnoreCase(name);
//            }
//        } else {
//            results = List.of(); // empty list — JSP shows hero, not results
//        }
//
//        model.addAttribute("artists", results);   // used by <c:forEach var="artist" items="${artists}">
//        return "search"; // re-uses index.jsp; EL shows results section when ${artists} is non-empty
//    }
    
// 	More production type search using MongoDB Lucene    
    
    @GetMapping("/search")
    public String search(@RequestParam(required = false) String name, 
    					@RequestParam(required= false) String genre ,
    					@RequestParam(defaultValue = "0") int page , Model model)
    {
    	ArtistSlice results =sRepo.findByNameAndGenre(name, genre, page);
    	model.addAttribute("artists", results);  
        return "search";
    }
    
    @GetMapping("artist-details/{artistId}")
    public String getArtistDetails(@PathVariable String artistId, Model model)
    {
    	Artist artist = artistRepo.findById(artistId).orElse(null);
    	model.addAttribute("artist", artist);
    	return "Artist";
    }
    
    @GetMapping("artist-details/{artistId}/add-song")
    public String addSong(@PathVariable String artistId, Model model) {
    	Artist artist = artistRepo.findById(artistId).orElse(null);
    	model.addAttribute("artist", artist);
    	model.addAttribute("artistId", artistId);
    	return "addSong";
    }
    
    @GetMapping("artist-details/{artistId}/edit-song/{songId}")
    public String editSong(@PathVariable String artistId, @PathVariable String songId, Model model) {
    	Artist artist = artistRepo.findById(artistId).orElse(null);
    	model.addAttribute("artist", artist);
    	model.addAttribute("songId", songId);
    	model.addAttribute("artistId", artistId);
    	return "editSong";
    }

    @GetMapping("/add")
    public String showAddArtistForm() {
        return "addArtist";
    }
    
    @GetMapping("artist/manage/{id}")
    public String manageArtistPage(@PathVariable String id, Model model)
    {
    	model.addAttribute("artistId", id);
    	return "manageArtist";
    }
    
    @GetMapping("artist/edit/{id}")
    public String editArtistPage(@PathVariable String id, Model model)
    {
    	model.addAttribute("artistId", id);
    	return "editArtist";
    }
    
    @GetMapping("/register")
    public String registerUser() {
    	return "registerArtist";
    }
    
    @GetMapping("/library")
    public String libraryPage() 
    {
    	return "library";
    }
    
    @GetMapping("/genre/{genre}")
    public String genrePage(@PathVariable String genre,  Model model) {
    	model.addAttribute("genre", genre);
    	return "genre";
    }
    
    @RequestMapping("/login")
    public String loginUser(@RequestParam(required = false) String error, HttpServletRequest req, Model model)
    {
    	if(error!=null)
    	{
    		HttpSession session= req.getSession(false);
    		String errorMessage= "Invalid username or password";
    		
    		if(session!=null)
    		{
    			Exception ex= (Exception) session.getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
    			if(ex!=null)
    				errorMessage= ex.getMessage();
    		}
		model.addAttribute("error", errorMessage);
    	}
    	return "login";
    }

//     * Keys match the EL expressions used in index.jsp:
//     *   ${stats.totalArtists}  ${stats.totalGenres}  ${stats.totalCountries}
//     */
    private Map<String, Long> buildStats() {
        long totalArtists = mongoTemplate.getCollection("Artist").countDocuments();

        long totalGenres = mongoTemplate.getCollection("Artist")
                .distinct("genre", String.class)
                .into(new HashSet<>())
                .size();

        long totalCountries = mongoTemplate.getCollection("Artist")
                .distinct("country", String.class)
                .into(new HashSet<>())
                .size();

        return Map.of(
            "totalArtists",   totalArtists,
            "totalGenres",    totalGenres,
            "totalCountries", totalCountries
        );
    }
}