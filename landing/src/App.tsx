import { AppStateProvider } from "./context/AppState";
import { ArtistShowcase } from "./components/ArtistShowcase";
import { CollectionSection } from "./components/CollectionSection";
import { DiscoverSection } from "./components/DiscoverSection";
import { FinalCTA } from "./components/FinalCTA";
import { Footer } from "./components/Footer";
import { Hero } from "./components/Hero";
import { LoginSection } from "./components/LoginSection";
import { Navbar } from "./components/Navbar";
import { SongList } from "./components/SongList";

export default function App() {
  return (
    <AppStateProvider>
      <div className="grain" aria-hidden="true" />
      <Navbar />
      <main>
        <Hero />
        <DiscoverSection />
        <ArtistShowcase />
        <SongList />
        <CollectionSection />
        <LoginSection />
        <FinalCTA />
      </main>
      <Footer />
    </AppStateProvider>
  );
}
