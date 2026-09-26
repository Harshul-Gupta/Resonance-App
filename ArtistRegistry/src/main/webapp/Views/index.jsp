<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
			<!DOCTYPE html>
			<html lang="en">

			<head>
				<meta charset="UTF-8" />
				<meta name="viewport" content="width=device-width, initial-scale=1.0" />
				<title>Resonance — Music Artist Registry</title>
				<link rel="icon" type="image/x-icon" href="/favicon.ico" />
				<link rel="preconnect" href="https://fonts.googleapis.com" />
				<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
				<link
					href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=Syne:wght@400;500;600;700&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,700;1,9..40,300&display=swap"
					rel="stylesheet" />
				<style>
					*,
					*::before,
					*::after {
						box-sizing: border-box;
						margin: 0;
						padding: 0;
					}

					:root {
						--red: #e8302a;
						--red-light: #ff6b5b;
						--red-deep: #9b1a15;
						--blue: #2563eb;
						--blue-light: #60a5fa;
						--blue-deep: #1e3a8a;
						--grad: linear-gradient(135deg, var(--red) 0%, #8b2be2 50%, var(--blue) 100%);
						--text-primary: #ffffff;
						--text-secondary: #b3b3b3;
						--text-muted: #727272;
						--spotify-dark: #121212;
						--spotify-input: #242424;
						--spotify-hover: #2a2a2a;
						--nav-h: 72px;
					}

					html {
						scroll-behavior: smooth;
					}

					body {
						min-height: 100vh;
						background: #07050f;
						background-image: radial-gradient(ellipse 80% 60% at 15% 10%, rgba(120, 10, 8, 0.4) 0%, transparent 60%),
							radial-gradient(ellipse 70% 55% at 88% 85%, rgba(20, 40, 160, 0.35) 0%, transparent 60%);
						color: var(--text-primary);
						font-family: 'DM Sans', sans-serif;
						font-size: 15px;
						line-height: 1.6;
						overflow-x: hidden;
					}

					.bg-canvas {
						position: fixed;
						inset: 0;
						z-index: 0;
						overflow: hidden;
						pointer-events: none;
					}

					.orb {
						position: absolute;
						border-radius: 50%;
						filter: blur(140px);
						animation: drift 22s ease-in-out infinite alternate;
					}

					.orb-1 {
						width: 820px;
						height: 820px;
						background: #8b0a06;
						opacity: .15;
						top: -300px;
						left: -240px;
					}

					@keyframes drift {
						0% {
							transform: translate(0, 0) scale(1);
						}

						100% {
							transform: translate(30px, -20px) scale(1.03);
						}
					}

					.wrapper {
						position: relative;
						z-index: 1;
						max-width: 1250px;
						margin: 0 auto;
						padding: 0 2rem;
					}

					/* SPOTIFY NAV STYLES */
					nav {
						position: sticky;
						top: 0;
						z-index: 300;
						height: var(--nav-h);
						display: flex;
						align-items: center;
						background: #000000;
						border-bottom: 1px solid rgba(255, 255, 255, 0.1);
					}

					.nav-inner {
						display: grid;
						grid-template-columns: 200px 1fr auto;
						align-items: center;
						width: 100%;
						gap: 1.5rem;
					}

					/* Iridescent Glass Logo Module */
					.logo {
						text-decoration: none;
						display: flex;
						align-items: center;
						gap: 10px;
						justify-self: start;
					}

					.logo-icon {
						width: 32px;
						height: 32px;
						flex-shrink: 0;
					}

					.logo-name {
						font-family: 'Syne', sans-serif;
						font-size: 20px;
						font-weight: 700;
						letter-spacing: 0.04em;
						text-transform: uppercase;
						background: linear-gradient(110deg, #c4bfff 0%, #a78bfa 50%, #f0abfc 100%);
						-webkit-background-clip: text;
						-webkit-text-fill-color: transparent;
						background-clip: text;
					}

					/* Embedded Central Search Field */
					.nav-center {
						display: flex;
						justify-content: center;
						width: 100%;
					}

					.nav-search-form {
						width: 100%;
						max-width: 420px;
						position: relative;
					}

					.nav-search-wrapper {
						position: relative;
						display: flex;
						align-items: center;
					}

					.nav-search-icon {
						position: absolute;
						left: 14px;
						color: var(--text-secondary);
						pointer-events: none;
						width: 18px;
						height: 18px;
						transition: color 0.2s;
					}

					.nav-search-input {
						width: 100%;
						background: var(--spotify-input);
						border: 1px solid transparent;
						border-radius: 500px;
						color: #ffffff;
						font-family: 'DM Sans', sans-serif;
						font-size: 0.88rem;
						font-weight: 400;
						padding: 0.65rem 1rem 0.65rem 2.8rem;
						outline: none;
						transition: background 0.2s, border-color 0.2s;
					}

					.nav-search-input::placeholder {
						color: var(--text-muted);
					}

					.nav-search-input:hover {
						background: var(--spotify-hover);
					}

					.nav-search-input:focus {
						background: var(--spotify-hover);
						border-color: #ffffff;
					}

					.nav-search-submit {
						display: none;
					}

					/* Right Controls */
					.nav-right {
						display: flex;
						align-items: center;
						gap: 1rem;
						justify-self: end;
					}

					.nav-links {
						display: flex;
						align-items: center;
						gap: 0.5rem;
						list-style: none;
					}

					.nav-links a,
					.nav-dropdown-toggle {
						color: var(--text-secondary);
						text-decoration: none;
						font-size: 0.88rem;
						font-weight: 700;
						padding: 0.5rem 1rem;
						border-radius: 500px;
						transition: color 0.2s, transform 0.2s;
						display: flex;
						align-items: center;
						gap: 6px;
						background: none;
						border: none;
						font-family: 'DM Sans', sans-serif;
						cursor: pointer;
					}

					.nav-links a:hover,
					.nav-dropdown-toggle:hover {
						color: #ffffff;
						transform: scale(1.04);
					}

					/* Solid High-Contrast Utility Button */
					.nav-links .btn-library {
						background: #ffffff;
						color: #000000;
						padding: 0.6rem 1.25rem;
					}

					.nav-links .btn-library:hover {
						background: #f6f6f6;
						color: #000000;
						transform: scale(1.04);
					}

					/* Standalone Content Genre Row */
					.genre-filter-row {
						display: flex;
						justify-content: center;
						gap: 0.5rem;
						flex-wrap: wrap;
						margin-top: 1.5rem;
					}

					.chip {
						font-size: 0.82rem;
						font-family: 'DM Sans', sans-serif;
						font-weight: 700;
						padding: 0.4rem 1rem;
						border-radius: 500px;
						border: none;
						background: #232323;
						color: #ffffff;
						cursor: pointer;
						transition: background 0.2s;
						user-select: none;
					}

					.chip:hover {
						background: #2a2a2a;
					}

					.chip.active {
						background: #ffffff;
						color: #000000;
					}

					/* HERO SECTION */
					.hero {
						padding: 6rem 0 3.5rem;
						text-align: center;
						display: flex;
						flex-direction: column;
						align-items: center;
					}

					.hero-eyebrow {
						font-family: 'Syne', sans-serif;
						font-size: 0.75rem;
						font-weight: 700;
						letter-spacing: 0.25em;
						text-transform: uppercase;
						color: var(--red-light);
						margin-bottom: 1.2rem;
					}

					.hero h1 {
						font-family: 'Cormorant Garamond', serif;
						font-size: clamp(3.2rem, 6vw, 5.5rem);
						font-weight: 300;
						line-height: 1.1;
						color: var(--text-primary);
						margin-bottom: 1.3rem;
						max-width: 800px;
					}

					.hero h1 em {
						font-style: italic;
						background: linear-gradient(100deg, #c4bfff 0%, #f0abfc 100%);
						-webkit-background-clip: text;
						-webkit-text-fill-color: transparent;
						background-clip: text;
					}

					.hero-sub {
						font-size: 1.05rem;
						color: var(--text-secondary);
						max-width: 520px;
						line-height: 1.7;
					}

					/* DROPDOWNS & PROFILE PANEL */
					.nav-dropdown {
						position: relative;
					}

					.nav-dropdown-menu {
						position: absolute;
						top: calc(100% + 10px);
						right: 0;
						min-width: 180px;
						background: #282828;
						border-radius: 4px;
						padding: 0.25rem;
						box-shadow: 0 16px 24px rgba(0, 0, 0, 0.5);
						opacity: 0;
						pointer-events: none;
						transition: opacity 0.15s;
						z-index: 500;
					}

					.nav-dropdown.open .nav-dropdown-menu {
						opacity: 1;
						pointer-events: auto;
					}

					.dropdown-item {
						display: flex;
						align-items: center;
						gap: 10px;
						color: #e5e5e5;
						text-decoration: none;
						font-size: 0.88rem;
						font-weight: 700;
						padding: 0.6rem 0.85rem;
						border-radius: 2px;
						transition: background 0.2s;
					}

					.dropdown-item:hover {
						color: #ffffff;
						background: rgba(255, 255, 255, 0.1);
					}

					.user-dropdown {
						position: relative;
					}

					.user-avatar-btn {
						display: flex;
						align-items: center;
						gap: 0.5rem;
						background: #000000;
						border-radius: 500px;
						padding: 3px 8px 3px 3px;
						cursor: pointer;
					}

					.user-avatar-btn:hover {
						background: var(--spotify-hover);
					}

					.avatar-circle {
						width: 28px;
						height: 28px;
						border-radius: 50%;
						background: #535353;
						display: flex;
						align-items: center;
						justify-content: center;
						font-size: 0.75rem;
						font-weight: 700;
						color: #fff;
						text-transform: uppercase;
					}

					.user-avatar-btn .user-name {
						font-size: 0.88rem;
						font-weight: 700;
						color: #ffffff;
						max-width: 100px;
						overflow: hidden;
						text-overflow: ellipsis;
						white-space: nowrap;
					}

					.user-avatar-btn svg {
						color: var(--text-secondary);
					}

					.user-dropdown-menu {
						position: absolute;
						top: calc(100% + 10px);
						right: 0;
						min-width: 190px;
						background: #282828;
						border-radius: 4px;
						padding: 0.25rem;
						box-shadow: 0 16px 24px rgba(0, 0, 0, 0.5);
						opacity: 0;
						pointer-events: none;
						z-index: 500;
					}

					.user-dropdown.open .user-dropdown-menu {
						opacity: 1;
						pointer-events: auto;
					}

					.signout-item {
						display: flex;
						align-items: center;
						gap: 10px;
						color: #e5e5e5;
						text-decoration: none;
						font-size: 0.88rem;
						font-weight: 700;
						padding: 0.6rem 0.85rem;
						border-radius: 2px;
						background: none;
						border: none;
						font-family: 'DM Sans', sans-serif;
						width: 100%;
						cursor: pointer;
					}

					.signout-item:hover {
						background: rgba(255, 255, 255, 0.1);
						color: #fff;
					}

					/* CTA FOOTER */
					.cta-section {
						padding: 4rem 0 7rem;
						text-align: center;
					}

					.cta-card {
						background: #121212;
						border: 1px solid rgba(255, 255, 255, 0.05);
						border-radius: 8px;
						padding: 4rem 2rem;
						max-width: 760px;
						margin: 0 auto;
					}

					.cta-card h2 {
						font-family: 'Cormorant Garamond', serif;
						font-size: clamp(2rem, 4vw, 3rem);
						font-weight: 300;
						margin-bottom: 1rem;
					}

					.cta-card p {
						color: var(--text-secondary);
						font-size: .95rem;
						margin-bottom: 2rem;
					}

					.btn-cta {
						display: inline-flex;
						align-items: center;
						gap: 8px;
						background: #ffffff;
						color: #000000;
						font-weight: 700;
						text-decoration: none;
						padding: 0.8rem 2rem;
						border-radius: 500px;
						transition: transform 0.2s;
					}

					.btn-cta:hover {
						transform: scale(1.04);
					}

					.cta-stats {
						display: flex;
						justify-content: center;
						gap: 4rem;
						margin-top: 3rem;
						padding-top: 2rem;
						border-top: 1px solid rgba(255, 255, 255, 0.05);
					}

					.stat-value {
						font-size: 2rem;
						font-weight: 700;
						color: #fff;
						display: block;
					}

					.stat-label {
						font-size: .75rem;
						color: var(--text-muted);
						text-transform: uppercase;
						font-weight: 700;
					}

					footer {
						border-top: 1px solid rgba(255, 255, 255, 0.05);
						padding: 2rem 0;
						text-align: center;
					}

					footer p {
						font-size: .8rem;
						color: var(--text-muted);
					}

					footer a {
						color: #fff;
						text-decoration: none;
					}
				</style>
			</head>

			<body>

				<div class="bg-canvas" aria-hidden="true">
					<div class="orb orb-1"></div>
				</div>

				<nav id="main-nav">
					<div class="wrapper" style="width:100%;">
						<div class="nav-inner">

							<!-- Left: Brand Logo Container -->
							<a href="${pageContext.request.contextPath}/" class="logo">
								<svg class="logo-icon" viewBox="0 0 32 32" fill="none"
									xmlns="http://www.w3.org/2000/svg">
									<circle cx="16" cy="16" r="15" stroke="url(#bgi)" stroke-width="1.5" />
									<circle cx="16" cy="16" r="9" stroke="rgba(255,255,255,0.15)" stroke-width="0.8" />
									<circle cx="16" cy="16" r="3" fill="#a78bfa" />
									<defs>
										<linearGradient id="bgi" x1="0" y1="0" x2="32" y2="32"
											gradientUnits="userSpaceOnUse">
											<stop stop-color="#7b6cff" />
											<stop offset="1" stop-color="#f43f8e" />
										</linearGradient>
									</defs>
								</svg>
								<span class="logo-name">Resonance</span>
							</a>

							<!-- Center: Streamlined Integrated Search Input Module -->
							<div class="nav-center" role="search">
								<form method="get" action="${pageContext.request.contextPath}/search" id="search-form"
									class="nav-search-form">
									<div class="nav-search-wrapper">
										<svg class="nav-search-icon" viewBox="0 0 24 24" fill="none"
											stroke="currentColor" stroke-width="2" stroke-linecap="round"
											stroke-linejoin="round" aria-hidden="true">
											<circle cx="11" cy="11" r="8" />
											<line x1="21" y1="21" x2="16.65" y2="16.65" />
										</svg>
										<input id="search-input" name="name" class="nav-search-input" type="search"
											placeholder="What do you want to play?" autocomplete="off"
											aria-label="Search registry" value="${fn:escapeXml(param.name)}" />
										<input type="hidden" id="genre-input" name="genre"
											value="${fn:escapeXml(param.genre)}" />
									</div>
									<button type="submit" class="nav-search-submit">Search</button>
								</form>
							</div>

							<!-- Right: Navigation Options & Profile Routing -->
							<div class="nav-right">
								<ul class="nav-links">
									<li class="nav-dropdown" id="register-dropdown">
										<button class="nav-dropdown-toggle" aria-haspopup="true" aria-expanded="false"
											id="register-toggle">
											Register
											<svg width="12" height="12" viewBox="0 0 24 24" fill="none"
												stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
												stroke-linejoin="round" aria-hidden="true">
												<polyline points="6 9 12 15 18 9" />
											</svg>
										</button>
										<div class="nav-dropdown-menu" role="menu">
											<a href="${pageContext.request.contextPath}/add" class="dropdown-item"
												role="menuitem">Add Artist</a>
										</div>
									</li>
									<li>
										<a href="${pageContext.request.contextPath}/library" class="btn-library">
											Library
										</a>
									</li>
								</ul>

								<c:if test="${not empty currentUser}">
									<div class="user-dropdown" id="user-dropdown">
										<button class="user-avatar-btn" id="user-toggle" aria-haspopup="true"
											aria-expanded="false">
											<div class="avatar-circle" aria-hidden="true">
												<c:choose>
													<c:when test="${not empty currentUser.getInitials()}">
														${fn:escapeXml(currentUser.getInitials())}</c:when>
													<c:otherwise>${fn:substring(fn:escapeXml(currentUser.getUsername()),
														0, 2)}</c:otherwise>
												</c:choose>
											</div>
											<span class="user-name">${fn:escapeXml(currentUser.getUsername())}</span>
											<svg width="12" height="12" viewBox="0 0 24 24" fill="none"
												stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
												stroke-linejoin="round" aria-hidden="true">
												<polyline points="6 9 12 15 18 9" />
											</svg>
										</button>

										<div class="user-dropdown-menu" id="user-menu" role="menu">
											<a href="${pageContext.request.contextPath}/profile" class="dropdown-item"
												role="menuitem">Profile</a>
											<form method="post" action="${pageContext.request.contextPath}/logout"
												style="display:contents;">
												<button type="submit" class="signout-item" role="menuitem">Log
													out</button>
											</form>
										</div>
									</div>
								</c:if>
							</div>

						</div>
					</div>
				</nav>

				<main>
					<div class="wrapper">

						<!-- Standalone Filter Array Location -->
						<div class="genre-filter-row" role="group" aria-label="Filter genres">
							<button class="chip ${empty param.genre ? 'active' : ''}" data-genre="">All</button>
							<c:forEach var="g" items="${genres}">
								<button class="chip ${param.genre eq g ? 'active' : ''}" data-genre="${g}">${g}</button>
							</c:forEach>
						</div>

						<section class="hero" id="hero">
							<div class="hero-eyebrow">Verified Hub</div>
							<h1>Discover the voices<br />that shape <em>music</em></h1>
							<p class="hero-sub">Search across thousands of registered profiles — from rising creators to
								legendary industry institutions.</p>
						</section>

						<section class="cta-section" aria-labelledby="cta-heading">
							<div class="cta-card">
								<h2 id="cta-heading">Explore every registered artist</h2>
								<p>Browse the complete library catalogue — filter by specific sub-genres, production
									companies, or country codes seamlessly.</p>
								<div>
									<a href="${pageContext.request.contextPath}/library" class="btn-cta">
										Open Library
									</a>
								</div>

								<div class="cta-stats">
									<div class="stat-item">
										<span class="stat-value">${stats.totalArtists != null ? stats.totalArtists :
											'—'}</span>
										<span class="stat-label">Artists</span>
									</div>
									<div class="stat-item">
										<span class="stat-value">${stats.totalGenres != null ? stats.totalGenres :
											'—'}</span>
										<span class="stat-label">Genres</span>
									</div>
									<div class="stat-item">
										<span class="stat-value">${stats.totalCountries != null ? stats.totalCountries :
											'—'}</span>
										<span class="stat-label">Countries</span>
									</div>
								</div>
							</div>
						</section>

					</div>
				</main>

				<footer>
					<div class="wrapper">
						<p>&copy; 2026 Resonance Registry &nbsp;&middot;&nbsp; <a href="#">About</a>
							&nbsp;&middot;&nbsp; <a href="#">Terms</a></p>
					</div>
				</footer>

				<script>
					// Filter pill trigger sync
					document.querySelectorAll('.chip').forEach(chip => {
						chip.addEventListener('click', () => {
							document.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
							chip.classList.add('active');
							document.getElementById('genre-input').value = chip.dataset.genre;
							document.getElementById('search-form').submit();
						});
					});

					// Structural Dropdown Components 
					const registerDropdown = document.getElementById('register-dropdown');
					const registerToggle = document.getElementById('register-toggle');
					registerToggle.addEventListener('click', (e) => {
						e.stopPropagation();
						const isOpen = registerDropdown.classList.toggle('open');
						registerToggle.setAttribute('aria-expanded', isOpen);
						if (userDropdown) userDropdown.classList.remove('open');
					});

					const userDropdown = document.getElementById('user-dropdown');
					const userToggle = document.getElementById('user-toggle');
					if (userDropdown && userToggle) {
						userToggle.addEventListener('click', (e) => {
							e.stopPropagation();
							const isOpen = userDropdown.classList.toggle('open');
							registerDropdown.classList.remove('open');
						});
					}

					document.addEventListener('click', () => {
						registerDropdown.classList.remove('open');
						if (userDropdown) userDropdown.classList.remove('open');
					});
				</script>
			</body>

			</html>