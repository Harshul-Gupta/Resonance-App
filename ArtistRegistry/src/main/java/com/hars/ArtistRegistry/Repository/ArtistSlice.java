package com.hars.ArtistRegistry.Repository;

import java.util.List;

public record ArtistSlice(List<Artist> content, boolean hasPrevious, boolean hasNext) {}
