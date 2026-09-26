<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb" autoFlush="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>${fn:escapeXml(genre)} — Resonance</title>
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
	<link
		href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=Syne:wght@400;500;600;700&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;1,9..40,300&display=swap"
		rel="stylesheet" />
	<style>
		*, *::before, *::after {
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
			--glass-bg: rgba(255, 255, 255, 0.038);
			--glass-border: rgba(255, 255, 255, 0.09);
			--text-primary: #f0eefa;
			--text-secondary: rgba(240, 238, 250, 0.52);
			--text-muted: rgba(240, 238, 250, 0.28);
			--nav-h: 66px;
		}

		html { scroll-behavior: smooth; }

		body {
			min-height: 100vh;
			background: #07050f;
			background-image:
				radial-gradient(ellipse 80% 60% at 15% 10%, rgba(120, 10, 8, 0.55) 0%, transparent 60%),
				radial-gradient(ellipse 70% 55% at 88% 85%, rgba(20, 40, 160, 0.45) 0%, transparent 60%),
				radial-gradient(ellipse 50% 40% at 50% 50%, rgba(80, 15, 120, 0.18) 0%, transparent 70%);
			color: var(--text-primary);
			font-family: 'DM Sans', sans-serif;
			font-size: 15px;
			line-height: 1.6;
			overflow-x: hidden;
		}

		.bg-canvas { position: fixed; inset: 0; z-index: 0; overflow: hidden; pointer-events: none; }
		.orb { position: absolute; border-radius: 50%; filter: blur(140px); animation: drift 22s ease-in-out infinite alternate; }
		.orb-1 { width: 820px; height: 820px; background: #8b0a06; opacity: .24; top: -300px; left: -240px; animation-duration: 24s; }
		.orb-2 { width: 600px; height: 600px; background: #0d2fa8; opacity: .22; bottom: -160px; right: -140px; animation-duration: 30s; animation-delay: -10s; }
		.orb-3 { width: 420px; height: 420px; background: #6b1fa8; opacity: .18; top: 38%; left: 50%; animation-duration: 26s; animation-delay: -6s; }
		.orb-4 { width: 300px; height: 300px; background: #c41612; opacity: .16; bottom: 28%; left: 7%; animation-duration: 34s; animation-delay: -16s; }

		@keyframes drift {
			0% { transform: translate(0, 0) scale(1); }
			33% { transform: translate(45px, -38px) scale(1.06); }
			66% { transform: translate(-32px, 52px) scale(0.96); }
			100% { transform: translate(22px, -22px) scale(1.03); }
		}

		.bg-canvas::after {
			content: '';
			position: absolute;
			inset: 0;
			background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
			opacity: .45;
		}

		.grid-lines {
			position: fixed;
			inset: 0;
			z-index: 0;
			pointer-events: none;
			background-image: linear-gradient(rgba(255, 255, 255, 0.018) 1px, transparent 1px), linear-gradient(90deg, rgba(255, 255, 255, 0.018) 1px, transparent 1px);
			background-size: 80px 80px;
			mask-image: radial-gradient(ellipse 88% 88% at 50% 45%, black 10%, transparent 100%);
		}

		.wrapper { position: relative; z-index: 1; max-width: 1250px; margin: 0 auto; padding: 0 2rem; }

		/* ── NAV ── */
		nav {
			position: sticky; top: 0; z-index: 300; height: var(--nav-h);
			display: flex; align-items: center;
			background: rgba(8, 3, 5, 0.45);
			backdrop-filter: blur(28px) saturate(160%);
			border-bottom: 1px solid rgba(255, 255, 255, 0.07);
			transition: background 0.45s;
		}
		nav.scrolled { background: rgba(8, 3, 5, 0.82); }
		.nav-inner { display: grid; grid-template-columns: 200px 1fr auto; align-items: center; width: 100%; gap: 1.5rem; }
		.logo { text-decoration: none; display: flex; align-items: center; gap: 10px; justify-self: start; }
		.logo-icon { width: 32px; height: 32px; flex-shrink: 0; }
		.logo-name {
			font-family: 'Syne', sans-serif; font-size: 20px; font-weight: 700; letter-spacing: 0.04em;
			text-transform: uppercase;
			background: linear-gradient(110deg, #c4bfff 0%, #a78bfa 50%, #f0abfc 100%);
			-webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
		}
		.nav-center { justify-self: stretch; }
		.nav-right { display: flex; align-items: center; gap: 1rem; justify-self: end; }
		.nav-links { display: flex; align-items: center; gap: 0.5rem; list-style: none; }
		.nav-links a, .nav-dropdown-toggle {
			color: var(--text-secondary); text-decoration: none; font-size: 0.88rem; font-weight: 700;
			padding: 0.5rem 1rem; border-radius: 500px; transition: color 0.2s, transform 0.2s;
			display: flex; align-items: center; gap: 6px; background: none; border: none;
			font-family: 'DM Sans', sans-serif; cursor: pointer;
		}
		.nav-links a:hover, .nav-dropdown-toggle:hover { color: #ffffff; transform: scale(1.04); }
		.nav-links .btn-library { background: #ffffff; color: #000000; padding: 0.6rem 1.25rem; }
		.nav-links .btn-library:hover { background: #f6f6f6; color: #000000; transform: scale(1.04); }
		.nav-dropdown { position: relative; }
		.nav-dropdown-menu {
			position: absolute; top: calc(100% + 10px); right: 0; min-width: 180px;
			background: #282828; border-radius: 4px; padding: 0.25rem;
			box-shadow: 0 16px 24px rgba(0, 0, 0, 0.5); opacity: 0; pointer-events: none;
			transition: opacity 0.15s; z-index: 500;
		}
		.nav-dropdown.open .nav-dropdown-menu { opacity: 1; pointer-events: auto; }
		.dropdown-item {
			display: flex; align-items: center; gap: 10px; color: #e5e5e5; text-decoration: none;
			font-size: 0.88rem; font-weight: 700; padding: 0.6rem 0.85rem; border-radius: 2px;
			transition: background 0.2s;
		}
		.dropdown-item:hover { color: #ffffff; background: rgba(255, 255, 255, 0.1); }
		.user-dropdown { position: relative; }
		.user-avatar-btn {
			display: flex; align-items: center; gap: 0.5rem; background: #000000;
			border-radius: 500px; padding: 3px 8px 3px 3px; cursor: pointer; border: none;
		}
		.avatar-circle {
			width: 28px; height: 28px; border-radius: 50%; background: #535353;
			display: flex; align-items: center; justify-content: center;
			font-size: 0.75rem; font-weight: 700; color: #fff; text-transform: uppercase;
		}
		.user-avatar-btn .user-name {
			font-size: 0.88rem; font-weight: 700; color: #ffffff; max-width: 100px;
			overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
		}
		.user-avatar-btn svg { color: var(--text-secondary); }
		.user-dropdown-menu {
			position: absolute; top: calc(100% + 10px); right: 0; min-width: 190px;
			background: #282828; border-radius: 4px; padding: 0.25rem;
			box-shadow: 0 16px 24px rgba(0, 0, 0, 0.5); opacity: 0; pointer-events: none; z-index: 500;
		}
		.user-dropdown.open .user-dropdown-menu { opacity: 1; pointer-events: auto; }
		.signout-item {
			display: flex; align-items: center; gap: 10px; color: #e5e5e5; text-decoration: none;
			font-size: 0.88rem; font-weight: 700; padding: 0.6rem 0.85rem; border-radius: 2px;
			background: none; border: none; font-family: 'DM Sans', sans-serif; width: 100%; cursor: pointer;
		}
		.signout-item:hover { background: rgba(255, 255, 255, 0.1); color: #fff; }

		/* ── PAGE HEADER ── */
		.page-header { padding: 2.8rem 0 2.2rem; border-bottom: 1px solid rgba(255, 255, 255, 0.06); margin-bottom: 2.8rem; }
		.breadcrumb {
			font-family: 'Syne', sans-serif; font-size: 0.68rem; font-weight: 600; letter-spacing: 0.22em;
			text-transform: uppercase; color: var(--text-muted); display: flex; align-items: center;
			gap: 0.55rem; margin-bottom: 0.85rem;
		}
		.breadcrumb a { color: var(--red); text-decoration: none; opacity: 0.82; transition: opacity 0.2s; }
		.breadcrumb a:hover { opacity: 1; }
		.breadcrumb svg { width: 10px; height: 10px; opacity: 0.4; }
		.page-title { font-family: 'Cormorant Garamond', serif; font-size: clamp(2rem, 4vw, 3rem); font-weight: 300; line-height: 1.1; }
		.page-title em {
			font-style: italic;
			background: linear-gradient(100deg, var(--red-light) 0%, var(--red) 55%, #ff8a80 100%);
			-webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
		}

		/* ── TILES GRID (matches search page: 5 columns) ── */
		.tiles-grid {
			display: grid;
			grid-template-columns: repeat(5, minmax(0, 1fr));
			align-items: start;
			gap: 1rem 1.4rem;
			padding-bottom: 3rem;
		}
		@media (max-width: 1100px) { .tiles-grid { grid-template-columns: repeat(4, minmax(0, 1fr)); } }
		@media (max-width: 800px) { .tiles-grid { grid-template-columns: repeat(3, minmax(0, 1fr)); } }
		@media (max-width: 520px) { .tiles-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); } }

		.hero-tile {
			position: relative; background: transparent; border: none; border-radius: 16px;
			overflow: visible; cursor: pointer; text-decoration: none;
			display: flex; flex-direction: column; align-items: center;
			width: 100%; min-width: 0; max-width: 100%;
			padding: 1rem 0.5rem 1.2rem;
			animation: tileIn 0.45s cubic-bezier(.22, 1, .36, 1) both;
			transition: transform 0.35s cubic-bezier(.22, 1, .36, 1);
		}
		.hero-tile:focus-visible { outline: 2px solid var(--red-light); outline-offset: 3px; border-radius: 50%; }
		.hero-tile:hover { transform: translateY(-5px); }

		@keyframes tileIn {
			from { opacity: 0; transform: translateY(22px) scale(0.95); }
			to { opacity: 1; transform: translateY(0) scale(1); }
		}

		.tile-photo-wrap {
			position: relative; width: 100%; aspect-ratio: 1 / 1; border-radius: 50%; overflow: hidden;
			margin-bottom: 0.85rem; flex-shrink: 0;
			box-shadow: 0 8px 32px rgba(0, 0, 0, 0.45);
			transition: box-shadow 0.35s, transform 0.35s cubic-bezier(.22, 1, .36, 1);
		}
		.hero-tile:hover .tile-photo-wrap {
			box-shadow: 0 16px 48px rgba(0, 0, 0, 0.60), 0 0 0 3px rgba(232, 48, 42, 0.30);
			transform: scale(1.06);
		}
		.hero-tile:nth-child(5n+2):hover .tile-photo-wrap { box-shadow: 0 16px 48px rgba(0,0,0,0.60), 0 0 0 3px rgba(139,43,226,0.38); }
		.hero-tile:nth-child(5n+3):hover .tile-photo-wrap { box-shadow: 0 16px 48px rgba(0,0,0,0.60), 0 0 0 3px rgba(37,99,235,0.38); }
		.hero-tile:nth-child(5n+4):hover .tile-photo-wrap { box-shadow: 0 16px 48px rgba(0,0,0,0.60), 0 0 0 3px rgba(232,48,42,0.30); }
		.hero-tile:nth-child(5n+5):hover .tile-photo-wrap { box-shadow: 0 16px 48px rgba(0,0,0,0.60), 0 0 0 3px rgba(59,130,246,0.38); }

		.tile-avatar { width: 100%; height: 100%; object-fit: cover; object-position: center top; display: block; border-radius: 50%; }
		.tile-avatar-monogram {
			width: 100%; height: 100%; display: flex; align-items: center; justify-content: center;
			font-family: 'Cormorant Garamond', serif; font-size: clamp(1.8rem, 6vw, 3rem); font-weight: 300;
			background: linear-gradient(135deg, rgba(232, 48, 42, 0.32), rgba(155, 26, 21, 0.20)); color: var(--text-primary);
		}
		.hero-tile:nth-child(5n+2) .tile-avatar-monogram { background: linear-gradient(135deg, rgba(107,31,168,0.35), rgba(91,33,182,0.20)); }
		.hero-tile:nth-child(5n+3) .tile-avatar-monogram { background: linear-gradient(135deg, rgba(37,99,235,0.35), rgba(30,58,138,0.20)); }

		.tile-photo-wrap::after {
			content: ''; position: absolute; inset: 0;
			background: radial-gradient(circle at 50% 50%, rgba(0,0,0,0.28) 0%, rgba(0,0,0,0.05) 70%);
			border-radius: 50%; opacity: 0; transition: opacity 0.28s;
		}
		.hero-tile:hover .tile-photo-wrap::after { opacity: 1; }

		.tile-body { width: 100%; min-width: 0; display: flex; flex-direction: column; align-items: center; text-align: center; padding: 0; position: relative; z-index: 1; }
		.tile-name {
			font-family: 'DM Sans', sans-serif; font-size: 0.88rem; font-weight: 500; line-height: 1.3;
			color: var(--text-primary); margin-bottom: 0.22rem; transition: color 0.2s;
			white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 100%;
		}
		.hero-tile:hover .tile-name { color: #fff; }
		.tile-genre {
			font-family: 'DM Sans', sans-serif; font-size: 0.75rem; font-weight: 400; color: var(--text-secondary);
			white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 100%;
		}
		.tile-meta { font-size: 0.72rem; color: var(--text-muted); margin-top: 0.1rem; }

		/* ── SKELETON LOADERS ── */
		.skeleton-tile { display: flex; flex-direction: column; align-items: center; padding: 1rem 0.5rem 1.2rem; }
		.skeleton-circle {
			width: 100%; aspect-ratio: 1 / 1; border-radius: 50%; margin-bottom: 0.85rem;
			background: linear-gradient(110deg, rgba(255,255,255,0.045) 8%, rgba(255,255,255,0.10) 18%, rgba(255,255,255,0.045) 33%);
			background-size: 200% 100%;
			animation: shimmer 1.6s ease-in-out infinite;
		}
		.skeleton-line {
			height: 10px; border-radius: 5px; margin-top: 8px;
			background: linear-gradient(110deg, rgba(255,255,255,0.045) 8%, rgba(255,255,255,0.10) 18%, rgba(255,255,255,0.045) 33%);
			background-size: 200% 100%;
			animation: shimmer 1.6s ease-in-out infinite;
		}
		.skeleton-line.name { width: 70%; }
		.skeleton-line.genre { width: 50%; }

		@keyframes shimmer {
			0% { background-position: 200% 0; }
			100% { background-position: -200% 0; }
		}

		/* ── SENTINEL / LOAD STATE ── */
		.scroll-sentinel { height: 1px; }
		.end-of-results {
			grid-column: 1 / -1;
			text-align: center;
			padding: 2.5rem 0 4rem;
			color: var(--text-muted);
			font-family: 'Syne', sans-serif;
			font-size: 0.78rem;
			font-weight: 600;
			letter-spacing: 0.12em;
			text-transform: uppercase;
		}
		.empty-state {
			grid-column: 1 / -1;
			display: flex; flex-direction: column; align-items: center;
			padding: 5rem 2rem; text-align: center;
		}
		.empty-icon {
			width: 72px; height: 72px; border-radius: 18px; background: rgba(255,255,255,0.04);
			border: 1px solid rgba(255,255,255,0.08); display: flex; align-items: center; justify-content: center;
			margin-bottom: 1.5rem;
		}
		.empty-state h3 { font-family: 'Cormorant Garamond', serif; font-size: 1.65rem; font-weight: 300; margin-bottom: 0.75rem; }
		.empty-state p { color: var(--text-secondary); font-size: 0.92rem; max-width: 360px; line-height: 1.72; }

		footer { border-top: 1px solid rgba(255, 255, 255, 0.07); padding: 2rem 0; text-align: center; }
		footer p { font-size: .8rem; color: var(--text-muted); }
		footer a { color: var(--red); text-decoration: none; opacity: .72; }
		footer a:hover { opacity: 1; }
	</style>
</head>

<body>

	<div class="bg-canvas" aria-hidden="true">
		<div class="orb orb-1"></div>
		<div class="orb orb-2"></div>
		<div class="orb orb-3"></div>
		<div class="orb orb-4"></div>
	</div>
	<div class="grid-lines" aria-hidden="true"></div>

	<%-- NAV --%>
	<nav id="main-nav" data-ctx="${pageContext.request.contextPath}">
		<div class="wrapper" style="width:100%;">
			<div class="nav-inner">
				<a href="${pageContext.request.contextPath}/" class="logo">
					<svg class="logo-icon" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
						<circle cx="16" cy="16" r="15" stroke="url(#bgi)" stroke-width="1.5" />
						<circle cx="16" cy="16" r="9" stroke="rgba(255,255,255,0.15)" stroke-width="0.8" />
						<circle cx="16" cy="16" r="3" fill="#a78bfa" />
						<defs>
							<linearGradient id="bgi" x1="0" y1="0" x2="32" y2="32" gradientUnits="userSpaceOnUse">
								<stop stop-color="#7b6cff" />
								<stop offset="1" stop-color="#f43f8e" />
							</linearGradient>
						</defs>
					</svg>
					<span class="logo-name">Resonance</span>
				</a>

				<div class="nav-center" role="search"></div>

				<div class="nav-right">
					<ul class="nav-links">
						<li class="nav-dropdown" id="register-dropdown">
							<button class="nav-dropdown-toggle" aria-haspopup="true" aria-expanded="false" id="register-toggle">
								Register
								<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
									<polyline points="6 9 12 15 18 9" />
								</svg>
							</button>
							<div class="nav-dropdown-menu" role="menu">
								<a href="${pageContext.request.contextPath}/add" class="dropdown-item" role="menuitem">Add Artist</a>
							</div>
						</li>
						<li>
							<a href="${pageContext.request.contextPath}/library" class="btn-library">Library</a>
						</li>
					</ul>

					<c:if test="${not empty currentUser}">
						<div class="user-dropdown" id="user-dropdown">
							<button class="user-avatar-btn" id="user-toggle" aria-haspopup="true" aria-expanded="false">
								<div class="avatar-circle" aria-hidden="true">
									<c:choose>
										<c:when test="${not empty currentUser.getInitials()}">
											${fn:escapeXml(currentUser.getInitials())}</c:when>
										<c:otherwise>
											${fn:substring(fn:escapeXml(currentUser.getUsername()), 0, 2)}</c:otherwise>
									</c:choose>
								</div>
								<span class="user-name">${fn:escapeXml(currentUser.getUsername())}</span>
								<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
									<polyline points="6 9 12 15 18 9" />
								</svg>
							</button>
							<div class="user-dropdown-menu" id="user-menu" role="menu">
								<a href="${pageContext.request.contextPath}/profile" class="dropdown-item" role="menuitem">Profile</a>
								<form method="post" action="${pageContext.request.contextPath}/logout" style="display:contents;">
									<button type="submit" class="signout-item" role="menuitem">Log out</button>
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

			<header class="page-header">
				<div class="breadcrumb">
					<a href="${pageContext.request.contextPath}/library">Library</a>
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
						<polyline points="9 18 15 12 9 6" />
					</svg>
					${fn:escapeXml(genre)}
				</div>
				<h1 class="page-title"><em>${fn:escapeXml(genre)}</em> Artists</h1>
			</header>

			<div class="tiles-grid" id="tiles-grid" role="list" aria-label="${fn:escapeXml(genre)} artists"></div>

			<div class="scroll-sentinel" id="scroll-sentinel"></div>
		</div>
	</main>

	<footer>
		<div class="wrapper">
			<p>Resonance Music Artist Registry &nbsp;&middot;&nbsp; <a href="#">API Docs</a>
				&nbsp;&middot;&nbsp; <a href="#">Privacy</a></p>
		</div>
	</footer>

	<script>
		/* ── Nav dropdowns / scroll effect (same as library.jsp) ── */
		var registerDropdown = document.getElementById('register-dropdown');
		var registerToggle = document.getElementById('register-toggle');
		var userDropdown = document.getElementById('user-dropdown');
		var userToggle = document.getElementById('user-toggle');

		if (registerToggle && registerDropdown) {
			registerToggle.addEventListener('click', function (e) {
				e.stopPropagation();
				var isOpen = registerDropdown.classList.toggle('open');
				registerToggle.setAttribute('aria-expanded', isOpen);
				if (userDropdown) {
					userDropdown.classList.remove('open');
					if (userToggle) userToggle.setAttribute('aria-expanded', 'false');
				}
			});
		}
		if (userToggle && userDropdown) {
			userToggle.addEventListener('click', function (e) {
				e.stopPropagation();
				var isOpen = userDropdown.classList.toggle('open');
				userToggle.setAttribute('aria-expanded', isOpen);
				if (registerDropdown) {
					registerDropdown.classList.remove('open');
					registerToggle.setAttribute('aria-expanded', 'false');
				}
			});
		}
		document.addEventListener('click', function () {
			if (registerDropdown) {
				registerDropdown.classList.remove('open');
				if (registerToggle) registerToggle.setAttribute('aria-expanded', 'false');
			}
			if (userDropdown) {
				userDropdown.classList.remove('open');
				if (userToggle) userToggle.setAttribute('aria-expanded', 'false');
			}
		});

		var nav = document.getElementById('main-nav');
		window.addEventListener('scroll', function () {
			nav.classList.toggle('scrolled', window.scrollY > 20);
		}, { passive: true });

		/* ── Infinite scroll for genre artists ── */
		(function () {
			var grid = document.getElementById('tiles-grid');
			var sentinel = document.getElementById('scroll-sentinel');
			var ctxPath = nav.getAttribute('data-ctx') || '';
			var genreName = decodeURIComponent(window.location.pathname.split('/').pop());
			var pageNum = 0;
			var hasNext = true;
			var isLoading = false;
			var loadedAny = false;
			var SKELETON_COUNT = 10; // matches limit+1 batch size (LIMIT_SIZE*2 = 10)

			function buildHeroTile(artist, index) {
				var hasPhoto = !!artist.imageURL;
				var delay = Math.min((index % 10) * 45, 360);
				var name = artist.name || '';
				var initial = name.charAt(0).toUpperCase() || '?';
				var artistId = artist.mongoId != null ? artist.mongoId : artist.id;

				var photo = '';
				if (hasPhoto) {
					photo = '<img class="tile-avatar" src="' + artist.imageURL + '" alt="' + name + '" '
						+ 'width="200" height="200" loading="lazy" decoding="async" '
						+ 'onerror="this.style.display=' + "'none'" + ';this.nextElementSibling.style.display=' + "'flex'" + '">';
				}

				var monogram = '<div class="tile-avatar-monogram" aria-hidden="true" style="'
					+ (hasPhoto ? 'display:none' : '') + '">' + initial + '</div>';

				var genreText = 'Artist';
				if (Array.isArray(artist.genre) && artist.genre.length) {
					genreText = artist.genre.join(' \u00B7 ');
				} else if (artist.genre) {
					genreText = artist.genre;
				}

				var meta = artist.country ? ('<div class="tile-meta">' + artist.country + '</div>') : '';

				return '<a href="' + ctxPath + '/artist-details/' + artistId + '" '
					+ 'class="hero-tile" style="animation-delay:' + delay + 'ms" '
					+ 'role="listitem" aria-label="' + name + '">'
					+ '<div class="tile-photo-wrap">' + photo + monogram + '</div>'
					+ '<div class="tile-body">'
					+ '<div class="tile-name">' + name + '</div>'
					+ '<div class="tile-genre">' + genreText + '</div>'
					+ meta
					+ '</div></a>';
			}

			function buildSkeletonTile() {
				return '<div class="skeleton-tile" role="listitem" aria-hidden="true">'
					+ '<div class="skeleton-circle"></div>'
					+ '<div class="skeleton-line name"></div>'
					+ '<div class="skeleton-line genre"></div>'
					+ '</div>';
			}

			function showSkeletons() {
				var html = '';
				for (var i = 0; i < SKELETON_COUNT; i++) html += buildSkeletonTile();
				grid.insertAdjacentHTML('beforeend', html);
			}

			function clearSkeletons() {
				var skeletons = grid.querySelectorAll('.skeleton-tile');
				skeletons.forEach(function (el) { el.remove(); });
			}

			function showEmptyState() {
				grid.innerHTML = '<div class="empty-state" role="listitem">'
					+ '<div class="empty-icon" aria-hidden="true">'
					+ '<svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="rgba(240,238,250,0.28)" stroke-width="1.5" stroke-linecap="round">'
					+ '<circle cx="11" cy="11" r="8" /><line x1="21" y1="21" x2="16.65" y2="16.65" />'
					+ '</svg></div>'
					+ '<h3>No artists yet</h3>'
					+ '<p>No artists have been added to <strong style="color:var(--text-primary)">' + genreName + '</strong> yet.</p>'
					+ '</div>';
			}

			function showEndOfResults() {
				grid.insertAdjacentHTML('beforeend', '<div class="end-of-results">— End of results —</div>');
			}

			function loadNextPage() {
			    if (isLoading || !hasNext) return;
			    isLoading = true;
			    showSkeletons();

			    fetch(ctxPath + '/api/artists/genre/' + encodeURIComponent(genreName) + '?pageNumber=' + pageNum)
			        .then(function (res) { return res.json(); })
			        .then(function (slice) {
			            clearSkeletons();

			            var artists = slice.content || slice.artists || [];
			            hasNext = !!slice.hasNext;

			            if (!artists.length && !loadedAny) {
			                showEmptyState();
			                isLoading = false;
			                return;
			            }

			            var html = '';
			            artists.forEach(function (a, i) { html += buildHeroTile(a, i); });
			            grid.insertAdjacentHTML('beforeend', html);

			            loadedAny = loadedAny || artists.length > 0;
			            pageNum += 1;
			            isLoading = false;

			            if (!hasNext && loadedAny) {
			                showEndOfResults();
			            } else {
			                // Sentinel may still be inside the viewport / rootMargin zone
			                // (short pages, tall screens) — IntersectionObserver won't refire
			                // without an exit/re-entry, so check manually and keep loading.
			                checkSentinelStillInView();
			            }
			        })
			        .catch(function (err) {
			            clearSkeletons();
			            console.error('Failed to load artists:', err);
			            isLoading = false;
			        });
			}

			function checkSentinelStillInView() {
			    var rect = sentinel.getBoundingClientRect();
			    var triggerZone = window.innerHeight + 400; // matches rootMargin: '400px'
			    if (rect.top <= triggerZone) {
			        loadNextPage();
			    }
			}

			var observer = new IntersectionObserver(function (entries) {
			    entries.forEach(function (entry) {
			        if (entry.isIntersecting) loadNextPage();
			    });
			}, { rootMargin: '400px 0px' });

			observer.observe(sentinel);

			// Initial load
			loadNextPage();
		})();
	</script>

</body>

</html>