package com.hars.ArtistRegistry.Controller;

import com.hars.ArtistRegistry.Service.SearchService;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.hars.ArtistRegistry.Event.ArtistEvent;
import com.hars.ArtistRegistry.Repository.Artist;
import com.hars.ArtistRegistry.Repository.ArtistRepo;
import com.hars.ArtistRegistry.Repository.ArtistSlice;
import com.hars.ArtistRegistry.Repository.UserResponseDTO;
import com.hars.ArtistRegistry.Service.ArtistService;
import com.hars.ArtistRegistry.Service.LibraryService;
import com.hars.ArtistRegistry.Service.RegisterService;
import com.hars.ArtistRegistry.Service.S3ImageService;

@RestController
@RequestMapping("api/artists")
public class HomeController {
	
	private final SearchService searchService;
	private final ArtistRepo repo;
	private final S3ImageService s3ImageService;
	private final ArtistService artistService;
	private final RegisterService registerService;
	private final LibraryService libraryService;
	
//	@Autowired
//	private SpotifyMetricService spotifyService;
	
	public HomeController(ArtistRepo repo, S3ImageService s3ImageService, ArtistService artistService, RegisterService registerService, LibraryService libraryService, SearchService searchService) {
		
		this.repo = repo;
		this.s3ImageService = s3ImageService;
		this.artistService = artistService;
		this.registerService = registerService;
		this.libraryService = libraryService;
		this.searchService = searchService;
	}
	
	
	
	@GetMapping("{id}")
	public ResponseEntity<Artist> getArtist(@PathVariable String id)
	{
		//3rd Part Rapid API to fetch Spotify Monthly listeners deprecated as it is a learning project 
		//Long liveListeners= spotifyService.getMonthlyListeners(artist.getSpotifyId());
		//Map<String, Object> response = new HashMap<>();
		//response.put("monthlyListeners", liveListeners);
        //response.put("artist", artist);
		Artist artist= repo.findById(id).orElse(null);
        
		return new ResponseEntity<>(artist, HttpStatus.OK);
	}
	
	@GetMapping("/search")
	public ResponseEntity<ArtistSlice> searchArtists(@RequestParam(required = false) String name,
            										 @RequestParam(required = false) String genre,
            										 @RequestParam(defaultValue = "0") int page) {	
		return ResponseEntity.ok(searchService.searchArtists(name, genre, page));
	}
	
	@PostMapping("/user")
	public ResponseEntity<String> saveUser(@RequestBody UserResponseDTO user)
	{
		registerService.registerArtist(user);
		return ResponseEntity.ok("User created successfuly!");
	}
	
	@PostMapping("/send")
	public ResponseEntity<Artist> addArtist(@RequestPart Artist artist, @RequestPart MultipartFile file) throws IOException
	{
		Artist createdArtist = artistService.createArtist(artist, file);
		return new ResponseEntity<Artist>(createdArtist, HttpStatus.CREATED);
	}
	
	@GetMapping("/topArtists")
	public ResponseEntity<List<Artist>> topArtists(@RequestParam(defaultValue = "0") int pageNumber){
		List<Artist> topArtists = libraryService.getTopArtists(pageNumber);
		return  ResponseEntity.ok(topArtists);
	}
	
	@GetMapping("genre/{genre}")
	public ResponseEntity<ArtistSlice> artistByGenre(@PathVariable String genre, @RequestParam(defaultValue = "0") int pageNumber){
		ArtistSlice artists = libraryService.getArtistsByGenre(genre, pageNumber);
		return ResponseEntity.ok(artists);
	}
	
	@PostMapping("/{mongoId}/view")
	public 	ResponseEntity<Void> updateViewCount(@PathVariable String mongoId){
		artistService.incrementViewCount(mongoId);
		return ResponseEntity.ok().build();
	}
	
	@PatchMapping("/{mongoId}")
	public ResponseEntity<Artist> editArtist(@PathVariable String mongoId, @RequestPart Map<String, Object> updates, @RequestPart MultipartFile file)
	{
		 return ResponseEntity.ok(artistService.updateArtist(mongoId, updates, file));
	}
	
	@DeleteMapping("/{mongoId}")
	public ResponseEntity<String> removeArtist(@PathVariable String mongoId)
	{
		artistService.deleteArtist(mongoId);
		return ResponseEntity.ok("Artist deleted successfully!");
	}
	
	@GetMapping("/artistEvents")
	public ResponseEntity<List<ArtistEvent>> getArtistEvents() {
		List<ArtistEvent> artistEvents = artistService.getArtistEvents();
		return ResponseEntity.ok(artistEvents);
	}
}
