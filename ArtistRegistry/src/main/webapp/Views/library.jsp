<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb" autoFlush="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>Library — Resonance</title>
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
	<link
		href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=Syne:wght@400;500;600;700&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;1,9..40,300&display=swap"
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
			--glass-bg: rgba(255, 255, 255, 0.038);
			--glass-border: rgba(255, 255, 255, 0.09);
			--text-primary: #f0eefa;
			--text-secondary: rgba(240, 238, 250, 0.52);
			--text-muted: rgba(240, 238, 250, 0.28);
			--nav-h: 66px;
		}

		html {
			scroll-behavior: smooth;
		}

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
			opacity: .24;
			top: -300px;
			left: -240px;
			animation-duration: 24s;
		}

		.orb-2 {
			width: 600px;
			height: 600px;
			background: #0d2fa8;
			opacity: .22;
			bottom: -160px;
			right: -140px;
			animation-duration: 30s;
			animation-delay: -10s;
		}

		.orb-3 {
			width: 420px;
			height: 420px;
			background: #6b1fa8;
			opacity: .18;
			top: 38%;
			left: 50%;
			animation-duration: 26s;
			animation-delay: -6s;
		}

		.orb-4 {
			width: 300px;
			height: 300px;
			background: #c41612;
			opacity: .16;
			bottom: 28%;
			left: 7%;
			animation-duration: 34s;
			animation-delay: -16s;
		}

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

		.wrapper {
			position: relative;
			z-index: 1;
			max-width: 1250px;
			margin: 0 auto;
			padding: 0 2rem;
		}

		/* ── NAV ── */
		nav {
			position: sticky;
			top: 0;
			z-index: 300;
			height: var(--nav-h);
			display: flex;
			align-items: center;
			background: rgba(8, 3, 5, 0.45);
			backdrop-filter: blur(28px) saturate(160%);
			border-bottom: 1px solid rgba(255, 255, 255, 0.07);
			transition: background 0.45s;
		}

		nav.scrolled {
			background: rgba(8, 3, 5, 0.82);
		}

		.nav-inner {
			display: grid;
			grid-template-columns: 200px 1fr auto;
			align-items: center;
			width: 100%;
			gap: 1.5rem;
		}

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

		.nav-center {
			justify-self: stretch;
		}

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

		.nav-links .btn-library.active {
			background: linear-gradient(135deg, #e8302a 0%, #9b1a15 100%);
			color: #fff;
		}

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
			border: none;
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

		/* ── PAGE HEADER ── */
		.page-header {
			padding: 2.8rem 0 2.2rem;
			border-bottom: 1px solid rgba(255, 255, 255, 0.06);
			margin-bottom: 2.8rem;
		}

		.page-title {
			font-family: 'Cormorant Garamond', serif;
			font-size: clamp(2rem, 4vw, 3rem);
			font-weight: 300;
			line-height: 1.1;
		}

		.page-title em {
			font-style: italic;
			background: linear-gradient(100deg, var(--red-light) 0%, var(--red) 55%, #ff8a80 100%);
			-webkit-background-clip: text;
			-webkit-text-fill-color: transparent;
			background-clip: text;
		}

		.section-label {
			font-family: 'Syne', sans-serif;
			font-size: 1.2rem;
			font-weight: 700;
			letter-spacing: 0.01em;
			color: var(--text-primary);
			margin-bottom: 1.4rem;
		}

		/* ── TOP 10 SHELF ── */
		.top-shelf {
			margin-bottom: 3.6rem;
		}

		.shelf-row {
			display: flex;
			align-items: center;
			gap: 1.8rem;
		}

		.shelf-label {
			flex: 0 0 auto;
			display: flex;
			align-items: center;
			justify-content: center;
			min-height: 150px;
			padding: 0 1.4rem 0 0;
			border-right: 1px solid rgba(255, 255, 255, 0.08);
		}

		.shelf-label-text {
			font-family: 'Cormorant Garamond', serif;
			font-size: 1.7rem;
			font-weight: 300;
			line-height: 1.15;
			background: linear-gradient(100deg, var(--red-light) 0%, var(--red) 55%, #ff8a80 100%);
			-webkit-background-clip: text;
			-webkit-text-fill-color: transparent;
			background-clip: text;
		}

		.shelf-body {
			flex: 1 1 auto;
			min-width: 0;
		}

		/* Matches search page's 5-column tile sizing exactly */
		.hero-tiles-track {
			display: grid;
			grid-template-columns: repeat(5, minmax(0, 1fr));
			align-items: start;
			gap: 1rem 1.4rem;
			padding: 0.6rem 0.2rem 0.4rem;
		}

		@media (max-width: 1100px) {
			.hero-tiles-track {
				grid-template-columns: repeat(4, minmax(0, 1fr));
			}
		}

		@media (max-width: 800px) {
			.hero-tiles-track {
				grid-template-columns: repeat(3, minmax(0, 1fr));
			}
		}

		@media (max-width: 520px) {
			.hero-tiles-track {
				grid-template-columns: repeat(2, minmax(0, 1fr));
			}
		}

		.empty-msg {
			grid-column: 1 / -1;
			color: var(--text-muted);
			font-size: 0.85rem;
			padding: 1rem 0.4rem;
		}

		/* Shelf pagination */
		.shelf-pagination {
			display: flex;
			align-items: center;
			justify-content: center;
			gap: 0.5rem;
			margin-top: 0.6rem;
		}

		.btn-page {
			position: relative;
			overflow: hidden;
			display: flex;
			align-items: center;
			justify-content: center;
			width: 38px;
			height: 38px;
			border-radius: 50%;
			border: 1px solid rgba(255, 255, 255, 0.10);
			background: rgba(255, 255, 255, 0.05);
			color: var(--text-secondary);
			cursor: pointer;
			transition: color 0.22s, background 0.22s, border-color 0.22s, transform 0.22s cubic-bezier(.22, 1, .36, 1), box-shadow 0.22s;
		}

		.btn-page svg {
			width: 15px;
			height: 15px;
		}

		.btn-page:hover:not(:disabled) {
			background: rgba(232, 48, 42, 0.12);
			border-color: rgba(232, 48, 42, 0.38);
			color: var(--red-light);
			transform: scale(1.08);
			box-shadow: 0 0 18px rgba(232, 48, 42, 0.20);
		}

		.btn-page:active:not(:disabled) {
			transform: scale(0.96);
		}

		.btn-page:disabled {
			opacity: 0.25;
			cursor: not-allowed;
		}

		.btn-page.loading svg {
			opacity: 0;
		}

		.btn-page.loading::before {
			content: '';
			position: absolute;
			width: 16px;
			height: 16px;
			border: 2px solid rgba(232, 48, 42, 0.30);
			border-top-color: var(--red-light);
			border-radius: 50%;
			animation: spin 0.7s linear infinite;
		}

		@keyframes spin {
			to { transform: rotate(360deg); }
		}

		.page-indicator {
			font-family: 'Syne', sans-serif;
			font-size: 0.72rem;
			font-weight: 600;
			letter-spacing: 0.1em;
			color: var(--text-muted);
			padding: 0 0.3rem;
			min-width: 3.5rem;
			text-align: center;
		}

		/* ── ARTIST CARD (Apple Music circle-photo style) ── */
		.hero-tile {
			position: relative;
			background: transparent;
			border: none;
			border-radius: 16px;
			overflow: visible;
			cursor: pointer;
			text-decoration: none;
			display: flex;
			flex-direction: column;
			align-items: center;
			width: 100%;
			min-width: 0;
			max-width: 100%;
			padding: 1rem 0.5rem 1.2rem;
			animation: tileIn 0.45s cubic-bezier(.22, 1, .36, 1) both;
			transition: transform 0.35s cubic-bezier(.22, 1, .36, 1);
		}

		.hero-tile:focus-visible {
			outline: 2px solid var(--red-light);
			outline-offset: 3px;
			border-radius: 50%;
		}

		.hero-tile:hover {
			transform: translateY(-5px);
		}

		@keyframes tileIn {
			from { opacity: 0; transform: translateY(22px) scale(0.95); }
			to { opacity: 1; transform: translateY(0) scale(1); }
		}

		.tile-photo-wrap {
			position: relative;
			width: 100%;
			aspect-ratio: 1 / 1;
			border-radius: 50%;
			overflow: hidden;
			margin-bottom: 0.85rem;
			flex-shrink: 0;
			box-shadow: 0 8px 32px rgba(0, 0, 0, 0.45);
			transition: box-shadow 0.35s, transform 0.35s cubic-bezier(.22, 1, .36, 1);
		}

		.hero-tile:hover .tile-photo-wrap {
			box-shadow: 0 16px 48px rgba(0, 0, 0, 0.60), 0 0 0 3px rgba(232, 48, 42, 0.30);
			transform: scale(1.06);
		}

		.hero-tile:nth-child(5n+2):hover .tile-photo-wrap {
			box-shadow: 0 16px 48px rgba(0, 0, 0, 0.60), 0 0 0 3px rgba(139, 43, 226, 0.38);
		}

		.hero-tile:nth-child(5n+3):hover .tile-photo-wrap {
			box-shadow: 0 16px 48px rgba(0, 0, 0, 0.60), 0 0 0 3px rgba(37, 99, 235, 0.38);
		}

		.hero-tile:nth-child(5n+4):hover .tile-photo-wrap {
			box-shadow: 0 16px 48px rgba(0, 0, 0, 0.60), 0 0 0 3px rgba(232, 48, 42, 0.30);
		}

		.hero-tile:nth-child(5n+5):hover .tile-photo-wrap {
			box-shadow: 0 16px 48px rgba(0, 0, 0, 0.60), 0 0 0 3px rgba(59, 130, 246, 0.38);
		}

		.tile-avatar {
			width: 100%;
			height: 100%;
			object-fit: cover;
			object-position: center top;
			display: block;
			border-radius: 50%;
		}

		.tile-avatar-monogram {
			width: 100%;
			height: 100%;
			display: flex;
			align-items: center;
			justify-content: center;
			font-family: 'Cormorant Garamond', serif;
			font-size: clamp(1.8rem, 6vw, 3rem);
			font-weight: 300;
			background: linear-gradient(135deg, rgba(232, 48, 42, 0.32), rgba(155, 26, 21, 0.20));
			color: var(--text-primary);
		}

		.hero-tile:nth-child(5n+2) .tile-avatar-monogram {
			background: linear-gradient(135deg, rgba(107, 31, 168, 0.35), rgba(91, 33, 182, 0.20));
		}

		.hero-tile:nth-child(5n+3) .tile-avatar-monogram {
			background: linear-gradient(135deg, rgba(37, 99, 235, 0.35), rgba(30, 58, 138, 0.20));
		}

		.tile-photo-wrap::after {
			content: '';
			position: absolute;
			inset: 0;
			background: radial-gradient(circle at 50% 50%, rgba(0, 0, 0, 0.28) 0%, rgba(0, 0, 0, 0.05) 70%);
			border-radius: 50%;
			opacity: 0;
			transition: opacity 0.28s;
		}

		.hero-tile:hover .tile-photo-wrap::after {
			opacity: 1;
		}

		.tile-body {
			width: 100%;
			min-width: 0;
			display: flex;
			flex-direction: column;
			align-items: center;
			text-align: center;
			padding: 0;
			position: relative;
			z-index: 1;
		}

		.tile-name {
			font-family: 'DM Sans', sans-serif;
			font-size: 0.88rem;
			font-weight: 500;
			line-height: 1.3;
			color: var(--text-primary);
			margin-bottom: 0.22rem;
			transition: color 0.2s;
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
			max-width: 100%;
		}

		.hero-tile:hover .tile-name {
			color: #fff;
		}

		.tile-genre {
			font-family: 'DM Sans', sans-serif;
			font-size: 0.75rem;
			font-weight: 400;
			color: var(--text-secondary);
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
			max-width: 100%;
		}

		.tile-meta {
			font-size: 0.72rem;
			color: var(--text-muted);
			margin-top: 0.1rem;
		}

		/* ── GENRE TILES ── */
		.genre-grid-section {
			padding-bottom: 5rem;
		}

		.genre-grid {
			display: grid;
			grid-template-columns: repeat(4, minmax(0, 1fr));
			gap: 1.1rem;
		}

		@media (max-width: 900px) {
			.genre-grid {
				grid-template-columns: repeat(3, minmax(0, 1fr));
			}
		}

		@media (max-width: 600px) {
			.genre-grid {
				grid-template-columns: repeat(2, minmax(0, 1fr));
			}
		}

		.genre-tile {
			position: relative;
			height: 140px;
			border-radius: 16px;
			display: flex;
			align-items: flex-end;
			padding: 1.1rem;
			text-decoration: none;
			color: #fff;
			border: 1px solid var(--glass-border);
			background-color: #1a1424;
			background-size: cover;
			background-position: center;
			overflow: hidden;
			transition: transform 0.32s cubic-bezier(.22, 1, .36, 1), box-shadow 0.32s;
			animation: tileIn 0.45s cubic-bezier(.22, 1, .36, 1) both;
		}

		.genre-tile::before {
			content: "";
			position: absolute;
			inset: 0;
			background: linear-gradient(180deg, rgba(7, 5, 15, 0.10) 0%, rgba(7, 5, 15, 0.88) 100%);
			transition: background 0.32s;
		}

		.genre-tile:hover {
			transform: translateY(-4px) scale(1.02);
			box-shadow: 0 14px 36px rgba(0, 0, 0, 0.5);
		}

		.genre-tile:nth-child(4n+1)::after,
		.genre-tile:nth-child(4n+2)::after,
		.genre-tile:nth-child(4n+3)::after,
		.genre-tile:nth-child(4n+4)::after {
			content: "";
			position: absolute;
			inset: 0;
			opacity: 0;
			transition: opacity 0.32s;
		}

		.genre-tile:nth-child(4n+1):hover::after {
			opacity: 1;
			box-shadow: inset 0 0 0 2px rgba(232, 48, 42, 0.4);
		}

		.genre-tile:nth-child(4n+2):hover::after {
			opacity: 1;
			box-shadow: inset 0 0 0 2px rgba(139, 43, 226, 0.4);
		}

		.genre-tile:nth-child(4n+3):hover::after {
			opacity: 1;
			box-shadow: inset 0 0 0 2px rgba(37, 99, 235, 0.4);
		}

		.genre-tile:nth-child(4n+4):hover::after {
			opacity: 1;
			box-shadow: inset 0 0 0 2px rgba(59, 130, 246, 0.4);
		}

		.genre-tile .genre-name {
			position: relative;
			z-index: 1;
			font-family: 'Syne', sans-serif;
			font-weight: 700;
			font-size: 1.05rem;
			letter-spacing: 0.01em;
			text-shadow: 0 2px 10px rgba(0, 0, 0, 0.55);
		}

		footer {
			border-top: 1px solid rgba(255, 255, 255, 0.07);
			padding: 2rem 0;
			text-align: center;
		}

		footer p {
			font-size: .8rem;
			color: var(--text-muted);
		}

		footer a {
			color: var(--red);
			text-decoration: none;
			opacity: .72;
		}

		footer a:hover {
			opacity: 1;
		}
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
							<a href="${pageContext.request.contextPath}/library" class="btn-library active">
								Library
							</a>
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
				<h1 class="page-title">Your <em>Library</em></h1>
			</header>

			<%-- ── TOP 10 ARTISTS SHELF ── --%>
			<section class="top-shelf">
				<div class="shelf-row">
					<div class="shelf-label">
						<span class="shelf-label-text">Top&nbsp;10<br>Artists</span>
					</div>

					<div class="shelf-body">
						<div id="topArtistsShelf" class="hero-tiles-track" role="list" aria-label="Top artists">
							<p class="empty-msg">Loading top artists&hellip;</p>
						</div>

						<div class="shelf-pagination" id="shelf-pagination">
							<button class="btn-page" id="shelf-prev" aria-label="Previous artists" disabled>
								<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
									<polyline points="15 18 9 12 15 6" />
								</svg>
							</button>
							<span class="page-indicator" id="shelf-page-indicator">1&nbsp;of 2</span>
							<button class="btn-page" id="shelf-next" aria-label="Next artists">
								<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
									<polyline points="9 18 15 12 9 6" />
								</svg>
							</button>
						</div>
					</div>
				</div>
			</section>

			<%-- ── GENRE TILES ── --%>
			<section class="genre-grid-section">
				<div class="section-label">Browse Genres</div>
				<div class="genre-grid">
					<c:forEach var="genre" items="${genres}">
						<c:url var="genreUrl" value="/genre/${genre}" />
						<a href="${genreUrl}"
						   class="genre-tile"
						   style="background-image:url('${pageContext.request.contextPath}/images/genres/${fn:toLowerCase(genre)}.jpg')">
							<span class="genre-name">${fn:escapeXml(genre)}</span>
						</a>
					</c:forEach>
				</div>
			</section>

		</div>
	</main>

	<footer>
		<div class="wrapper">
			<p>Resonance Music Artist Registry &nbsp;&middot;&nbsp; <a href="#">API Docs</a>
				&nbsp;&middot;&nbsp; <a href="#">Privacy</a></p>
		</div>
	</footer>

	<script>
		//── Navbar Dropdowns Toggle ──
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

		/* ── Scroll effect ── */
		var nav = document.getElementById('main-nav');
		window.addEventListener('scroll', function () {
			nav.classList.toggle('scrolled', window.scrollY > 20);
		}, { passive: true });

		/* ── Top artists shelf (paged, 5 per page) ── */
		var shelfPage = 0;
		var shelfMaxPage = 1; // topArtists returns 10 total, 5 per page → pages 0 and 1

		function buildHeroTile(artist, index) {
			var hasPhoto = !!artist.imageURL;
			var delay = Math.min(index * 45, 360);
			var name = artist.name || '';
			var initial = name.charAt(0).toUpperCase() || '?';
			var ctxPath = nav.getAttribute('data-ctx') || '';
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

		function loadTopArtists(page) {
			var shelf = document.getElementById('topArtistsShelf');
			var prevBtn = document.getElementById('shelf-prev');
			var nextBtn = document.getElementById('shelf-next');
			var pageInd = document.getElementById('shelf-page-indicator');
			var ctxPath = nav.getAttribute('data-ctx') || '';

			prevBtn.disabled = true;
			nextBtn.disabled = true;

			fetch(ctxPath + '/api/artists/topArtists?pageNumber=' + page)
				.then(function (res) { return res.json(); })
				.then(function (artists) {
					if (!artists.length) {
						shelf.innerHTML = '<p class="empty-msg">No artists yet.</p>';
					} else {
						var html = '';
						artists.forEach(function (a, i) {
							html += buildHeroTile(a, i);
						});
						shelf.innerHTML = html;
					}

					shelfPage = page;
					pageInd.textContent = 'Pg\u00A0' + (shelfPage + 1);
					prevBtn.disabled = (shelfPage <= 0);
					nextBtn.disabled = (shelfPage >= shelfMaxPage);
				})
				.catch(function (err) {
					shelf.innerHTML = '<p class="empty-msg">Couldn\'t load top artists.</p>';
					console.error(err);
					prevBtn.disabled = (shelfPage <= 0);
					nextBtn.disabled = (shelfPage >= shelfMaxPage);
				});
		}

		document.getElementById('shelf-prev').addEventListener('click', function () {
			if (shelfPage > 0) loadTopArtists(shelfPage - 1);
		});
		document.getElementById('shelf-next').addEventListener('click', function () {
			if (shelfPage < shelfMaxPage) loadTopArtists(shelfPage + 1);
		});

		document.addEventListener('DOMContentLoaded', function () {
			loadTopArtists(0);
		});
	</script>

</body>

</html>