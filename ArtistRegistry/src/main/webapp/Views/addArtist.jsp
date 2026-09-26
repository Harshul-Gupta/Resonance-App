<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<!DOCTYPE html>
		<html lang="en">

		<head>
			<meta charset="UTF-8" />
			<meta name="viewport" content="width=device-width, initial-scale=1.0" />
			<title>Add Artist — Resonance</title>
			<link rel="icon" type="image/x-icon" href="/favicon.ico" />
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
					background-image: radial-gradient(ellipse 80% 60% at 15% 10%, rgba(120, 10, 8, 0.55) 0%, transparent 60%),
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

				@keyframes drift {
					0% {
						transform: translate(0, 0) scale(1);
					}

					33% {
						transform: translate(45px, -38px) scale(1.06);
					}

					66% {
						transform: translate(-32px, 52px) scale(0.96);
					}

					100% {
						transform: translate(22px, -22px) scale(1.03);
					}
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
					max-width: 1100px;
					margin: 0 auto;
					padding: 0 2rem;
				}

				/* NAV */
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
					display: flex;
					align-items: center;
					justify-content: space-between;
					width: 100%;
				}

				.logo {
					font-family: 'Cormorant Garamond', serif;
					font-size: 1.5rem;
					font-weight: 300;
					letter-spacing: 0.08em;
					color: var(--text-primary);
					text-decoration: none;
					display: flex;
					align-items: center;
					gap: 0.6rem;
				}

				.logo-icon {
					width: 28px;
					height: 28px;
					background: linear-gradient(135deg, var(--red), var(--red-deep));
					border-radius: 6px;
					display: flex;
					align-items: center;
					justify-content: center;
				}

				.logo-icon svg {
					width: 16px;
					height: 16px;
					fill: #fff;
				}

				.logo span {
					color: var(--red-light);
					font-style: italic;
				}

				.nav-links {
					display: flex;
					align-items: center;
					gap: 0.2rem;
					list-style: none;
				}

				.nav-links a {
					color: var(--text-secondary);
					text-decoration: none;
					font-size: 0.84rem;
					font-weight: 500;
					letter-spacing: 0.06em;
					text-transform: uppercase;
					padding: 0.48rem 0.88rem;
					border-radius: 8px;
					transition: color 0.2s, background 0.2s;
				}

				.nav-links a:hover {
					color: var(--text-primary);
					background: rgba(255, 255, 255, 0.05);
				}

				.nav-links .btn-library {
					background: linear-gradient(135deg, rgba(232, 48, 42, 0.14), rgba(155, 26, 21, 0.14));
					border: 1px solid rgba(232, 48, 42, 0.32);
					color: var(--red-light);
					display: flex;
					align-items: center;
					gap: 6px;
				}

				.nav-links .btn-library:hover {
					background: linear-gradient(135deg, rgba(232, 48, 42, 0.26), rgba(155, 26, 21, 0.26));
					border-color: rgba(232, 48, 42, 0.6);
					color: #fff;
					transform: translateY(-1px);
				}

				/* DROPDOWN */
				.nav-dropdown {
					position: relative;
				}

				.nav-dropdown-toggle {
					color: var(--text-secondary);
					text-decoration: none;
					font-size: 0.84rem;
					font-weight: 500;
					letter-spacing: 0.06em;
					text-transform: uppercase;
					padding: 0.48rem 0.88rem;
					border-radius: 8px;
					transition: color 0.2s, background 0.2s;
					display: flex;
					align-items: center;
					gap: 5px;
					cursor: pointer;
					background: none;
					border: none;
					font-family: 'DM Sans', sans-serif;
				}

				.nav-dropdown-toggle:hover {
					color: var(--text-primary);
					background: rgba(255, 255, 255, 0.05);
				}

				.nav-dropdown-toggle svg {
					transition: transform 0.22s;
				}

				.nav-dropdown.open .nav-dropdown-toggle svg {
					transform: rotate(180deg);
				}

				.nav-dropdown-menu {
					position: absolute;
					top: calc(100% + 10px);
					right: 0;
					min-width: 200px;
					background: rgba(12, 5, 8, 0.92);
					backdrop-filter: blur(32px) saturate(180%);
					border: 1px solid rgba(255, 255, 255, 0.10);
					border-radius: 14px;
					padding: 0.5rem;
					box-shadow: 0 16px 48px rgba(0, 0, 0, 0.55), 0 0 0 1px rgba(232, 48, 42, 0.06);
					opacity: 0;
					pointer-events: none;
					transform: translateY(-6px);
					transition: opacity 0.22s, transform 0.22s;
					z-index: 500;
				}

				.nav-dropdown.open .nav-dropdown-menu {
					opacity: 1;
					pointer-events: auto;
					transform: translateY(0);
				}

				.dropdown-item {
					display: flex;
					align-items: center;
					gap: 10px;
					color: var(--text-secondary);
					text-decoration: none;
					font-size: 0.84rem;
					font-weight: 500;
					letter-spacing: 0.04em;
					padding: 0.6rem 0.85rem;
					border-radius: 9px;
					transition: color 0.2s, background 0.2s;
				}

				.dropdown-item:hover {
					color: var(--text-primary);
					background: rgba(255, 255, 255, 0.06);
				}

				.dropdown-item svg {
					color: var(--red-light);
					flex-shrink: 0;
				}

				.dropdown-divider {
					height: 1px;
					background: rgba(255, 255, 255, 0.07);
					margin: 0.3rem 0.5rem;
				}

				/* PAGE LAYOUT */
				main {
					padding: 4rem 0 8rem;
				}

				.page-header {
					text-align: center;
					margin-bottom: 3rem;
				}

				.page-eyebrow {
					font-family: 'Syne', sans-serif;
					font-size: 0.69rem;
					font-weight: 600;
					letter-spacing: 0.32em;
					text-transform: uppercase;
					color: var(--red);
					margin-bottom: 1rem;
					display: flex;
					align-items: center;
					justify-content: center;
					gap: 10px;
				}

				.page-eyebrow::before,
				.page-eyebrow::after {
					content: '';
					display: block;
					width: 28px;
					height: 1px;
					background: linear-gradient(90deg, transparent, var(--red));
				}

				.page-eyebrow::after {
					background: linear-gradient(90deg, var(--red), transparent);
				}

				.page-header h1 {
					font-family: 'Cormorant Garamond', serif;
					font-size: clamp(2.4rem, 5vw, 4rem);
					font-weight: 300;
					line-height: 1.1;
					margin-bottom: 0.8rem;
				}

				.page-header h1 em {
					font-style: italic;
					background: linear-gradient(100deg, var(--red-light) 0%, var(--red) 55%, #ff8a80 100%);
					-webkit-background-clip: text;
					-webkit-text-fill-color: transparent;
					background-clip: text;
				}

				.page-header p {
					color: var(--text-secondary);
					font-size: 0.96rem;
					max-width: 420px;
					margin: 0 auto;
				}

				/* FORM CARD */
				.form-card {
					max-width: 640px;
					margin: 0 auto;
					background: rgba(255, 255, 255, 0.038);
					backdrop-filter: blur(28px) saturate(160%);
					border: 1px solid rgba(255, 255, 255, 0.09);
					border-radius: 22px;
					padding: 2.8rem 2.6rem;
					box-shadow: 0 8px 60px rgba(0, 0, 0, 0.4), inset 0 1px 0 rgba(255, 255, 255, 0.07);
					position: relative;
					overflow: hidden;
				}

				.form-card::before {
					content: '';
					position: absolute;
					top: 0;
					left: 10%;
					right: 10%;
					height: 1px;
					background: linear-gradient(90deg, transparent, rgba(232, 48, 42, 0.5), rgba(255, 107, 96, 0.35), transparent);
				}

				/* FORM FIELDS */
				.form-grid {
					display: grid;
					grid-template-columns: 1fr 1fr;
					gap: 1.2rem 1.4rem;
				}

				.form-group {
					display: flex;
					flex-direction: column;
					gap: 0.42rem;
				}

				.form-group.full {
					grid-column: 1 / -1;
				}

				.form-label {
					font-family: 'Syne', sans-serif;
					font-size: 0.67rem;
					font-weight: 600;
					letter-spacing: 0.2em;
					text-transform: uppercase;
					color: var(--text-muted);
				}

				.form-label .required {
					color: var(--red-light);
					margin-left: 2px;
				}

				.form-input,
				.form-select,
				.form-textarea {
					background: rgba(255, 255, 255, 0.05);
					border: 1px solid rgba(255, 255, 255, 0.09);
					border-radius: 11px;
					color: var(--text-primary);
					font-family: 'DM Sans', sans-serif;
					font-size: 0.93rem;
					padding: 0.76rem 1rem;
					outline: none;
					transition: background 0.22s, border-color 0.22s, box-shadow 0.22s;
					width: 100%;
				}

				.form-input::placeholder,
				.form-textarea::placeholder {
					color: var(--text-muted);
				}

				.form-input:focus,
				.form-select:focus,
				.form-textarea:focus {
					background: rgba(255, 255, 255, 0.08);
					border-color: rgba(232, 48, 42, 0.40);
					box-shadow: 0 0 0 3px rgba(232, 48, 42, 0.08);
				}

				.form-select {
					appearance: none;
					cursor: pointer;
				}

				.form-select option {
					background: #0d0810;
					color: var(--text-primary);
				}

				.form-textarea {
					resize: vertical;
					min-height: 100px;
					line-height: 1.6;
				}

				.form-divider {
					grid-column: 1 / -1;
					height: 1px;
					background: rgba(255, 255, 255, 0.07);
					margin: 0.4rem 0;
				}

				/* GENRE CHECKBOXES */
				.genre-chips {
					display: flex;
					flex-wrap: wrap;
					gap: 0.45rem;
					margin-top: 0.2rem;
				}

				.genre-chip {
					cursor: pointer;
				}

				.genre-chip input[type="checkbox"] {
					position: absolute;
					opacity: 0;
					width: 0;
					height: 0;
				}

				.genre-chip span {
					display: inline-block;
					font-size: 0.72rem;
					font-family: 'Syne', sans-serif;
					font-weight: 500;
					padding: 0.28rem 0.82rem;
					border-radius: 100px;
					border: 1px solid rgba(255, 255, 255, 0.09);
					background: rgba(255, 255, 255, 0.04);
					color: var(--text-secondary);
					cursor: pointer;
					transition: all 0.2s;
					user-select: none;
				}

				.genre-chip span:hover {
					border-color: rgba(232, 48, 42, 0.4);
					background: rgba(232, 48, 42, 0.09);
					color: var(--red-light);
				}

				.genre-chip input:checked+span {
					border-color: rgba(232, 48, 42, 0.52);
					background: rgba(232, 48, 42, 0.14);
					color: var(--red-light);
				}

				/* SUBMIT */
				.form-actions {
					grid-column: 1 / -1;
					display: flex;
					gap: 0.9rem;
					margin-top: 0.6rem;
				}

				.btn-submit {
					flex: 1;
					background: linear-gradient(135deg, #e8302a 0%, #9b1a15 100%);
					color: #fff;
					font-family: 'Syne', sans-serif;
					font-size: 0.85rem;
					font-weight: 700;
					letter-spacing: 0.1em;
					text-transform: uppercase;
					border: none;
					border-radius: 12px;
					padding: 0.95rem 2rem;
					cursor: pointer;
					display: flex;
					align-items: center;
					justify-content: center;
					gap: 8px;
					position: relative;
					overflow: hidden;
					transition: transform 0.22s, box-shadow 0.22s, filter 0.22s;
				}

				.btn-submit::after {
					content: '';
					position: absolute;
					top: 0;
					left: -100%;
					width: 60%;
					height: 100%;
					background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.22), transparent);
					transition: left 0.45s ease;
				}

				.btn-submit:hover::after {
					left: 140%;
				}

				.btn-submit:hover {
					transform: translateY(-2px);
					box-shadow: 0 8px 28px rgba(232, 48, 42, 0.42);
					filter: brightness(1.08);
				}

				.btn-cancel {
					background: rgba(255, 255, 255, 0.05);
					border: 1px solid rgba(255, 255, 255, 0.09);
					color: var(--text-secondary);
					font-family: 'Syne', sans-serif;
					font-size: 0.85rem;
					font-weight: 600;
					letter-spacing: 0.08em;
					text-transform: uppercase;
					border-radius: 12px;
					padding: 0.95rem 1.6rem;
					cursor: pointer;
					text-decoration: none;
					display: flex;
					align-items: center;
					justify-content: center;
					transition: color 0.2s, background 0.2s, border-color 0.2s;
				}

				.btn-cancel:hover {
					color: var(--text-primary);
					background: rgba(255, 255, 255, 0.09);
					border-color: rgba(255, 255, 255, 0.18);
				}

				/* SUCCESS / ERROR banners */
				.alert {
					grid-column: 1 / -1;
					border-radius: 11px;
					padding: 0.85rem 1.1rem;
					font-size: 0.88rem;
					display: flex;
					align-items: center;
					gap: 10px;
					margin-bottom: 0.5rem;
				}

				.alert-success {
					background: rgba(34, 197, 94, 0.10);
					border: 1px solid rgba(34, 197, 94, 0.28);
					color: #86efac;
				}

				.alert-error {
					background: rgba(232, 48, 42, 0.10);
					border: 1px solid rgba(232, 48, 42, 0.28);
					color: var(--red-light);
				}

				/* FILE UPLOAD */
				.file-drop-zone {
					display: block;
					cursor: pointer;
					border-radius: 13px;
					border: 1.5px dashed rgba(255, 255, 255, 0.13);
					background: rgba(255, 255, 255, 0.03);
					transition: border-color 0.22s, background 0.22s;
					overflow: hidden;
					position: relative;
				}

				.file-drop-zone:hover,
				.file-drop-zone.drag-over {
					border-color: rgba(232, 48, 42, 0.5);
					background: rgba(232, 48, 42, 0.05);
				}

				.file-drop-inner {
					display: flex;
					flex-direction: column;
					align-items: center;
					justify-content: center;
					gap: 0.45rem;
					padding: 2rem 1.5rem;
					text-align: center;
				}

				.file-drop-icon {
					color: var(--text-muted);
					transition: color 0.22s;
				}

				.file-drop-zone:hover .file-drop-icon {
					color: var(--red-light);
				}

				.file-drop-text {
					font-size: 0.88rem;
					color: var(--text-secondary);
				}

				.file-drop-text u {
					color: var(--red-light);
					text-decoration-color: rgba(255, 107, 91, 0.4);
				}

				.file-drop-hint {
					font-size: 0.74rem;
					color: var(--text-muted);
					letter-spacing: 0.04em;
				}

				.file-input-hidden {
					position: absolute;
					inset: 0;
					opacity: 0;
					cursor: pointer;
					width: 100%;
					height: 100%;
				}

				.image-preview {
					width: 100%;
					max-height: 220px;
					object-fit: cover;
					display: block;
					border-radius: 11px;
				}

				.image-preview.hidden {
					display: none;
				}

				.file-drop-inner.hidden {
					display: none;
				}

				.file-name-label {
					display: block;
					margin-top: 0.45rem;
					font-size: 0.76rem;
					color: var(--text-muted);
					letter-spacing: 0.03em;
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

				@media (max-width: 560px) {
					.form-grid {
						grid-template-columns: 1fr;
					}

					.form-card {
						padding: 2rem 1.4rem;
					}

					.form-actions {
						flex-direction: column;
					}
				}
			</style>
		</head>

		<body>

			<div class="bg-canvas" aria-hidden="true">
				<div class="orb orb-1"></div>
				<div class="orb orb-2"></div>
				<div class="orb orb-3"></div>
			</div>
			<div class="grid-lines" aria-hidden="true"></div>

			<%-- ════ NAV (identical to index.jsp) ════ --%>
				<nav id="main-nav">
					<div class="wrapper">
						<div class="nav-inner">
							<a href="${pageContext.request.contextPath}/" class="logo">
								<div class="logo-icon" aria-hidden="true">
									<svg viewBox="0 0 24 24">
										<path
											d="M12 3a9 9 0 100 18A9 9 0 0012 3zm0 2a7 7 0 110 14A7 7 0 0112 5zm-1 3v5.586l-2.707 2.707 1.414 1.414L13 15.414V8h-2z" />
									</svg>
								</div>
								Reso<span>nance</span>
							</a>
							<ul class="nav-links">
								<li><a href="#">About</a></li>
								<li><a href="#">Genres</a></li>
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
										<a href="${pageContext.request.contextPath}/artist/add" class="dropdown-item"
											role="menuitem">
											<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
												stroke="currentColor" stroke-width="2" stroke-linecap="round"
												stroke-linejoin="round" aria-hidden="true">
												<circle cx="12" cy="8" r="4" />
												<path d="M20 21a8 8 0 1 0-16 0" />
												<line x1="19" y1="8" x2="19" y2="14" />
												<line x1="16" y1="11" x2="22" y2="11" />
											</svg>
											Add Artist
										</a>
										<div class="dropdown-divider"></div>
										<a href="${pageContext.request.contextPath}/artists" class="dropdown-item"
											role="menuitem">
											<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
												stroke="currentColor" stroke-width="2" stroke-linecap="round"
												stroke-linejoin="round" aria-hidden="true">
												<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
												<path
													d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
											</svg>
											Browse Library
										</a>
									</div>
								</li>
								<li>
									<a href="${pageContext.request.contextPath}/library" class="btn-library">
										<svg width="14" height="14" viewBox="0 0 24 24" fill="none"
											stroke="currentColor" stroke-width="2.2" stroke-linecap="round"
											stroke-linejoin="round" aria-hidden="true">
											<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
											<path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
										</svg>
										Artist Library
									</a>
								</li>
							</ul>
						</div>
					</div>
				</nav>

				<%-- ════ MAIN ════ --%>
					<main>
						<div class="wrapper">

							<header class="page-header">
								<div class="page-eyebrow">Artist Registry</div>
								<h1>Register a new <em>Artist</em></h1>
								<p>Add an artist to the Resonance registry. All registered artists appear in the public
									library.</p>
							</header>

							<%-- Success / error flash messages set by the controller via redirect attributes --%>
								<c:if test="${not empty successMessage}">
									<div style="max-width:640px;margin:0 auto 1.5rem;" role="alert">
										<div class="alert alert-success">
											<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
												stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
												stroke-linejoin="round" aria-hidden="true">
												<polyline points="20 6 9 17 4 12" />
											</svg>
											${successMessage}
										</div>
									</div>
								</c:if>
								<c:if test="${not empty errorMessage}">
									<div style="max-width:640px;margin:0 auto 1.5rem;" role="alert">
										<div class="alert alert-error">
											<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
												stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
												stroke-linejoin="round" aria-hidden="true">
												<circle cx="12" cy="12" r="10" />
												<line x1="12" y1="8" x2="12" y2="12" />
												<line x1="12" y1="16" x2="12.01" y2="16" />
											</svg>
											${errorMessage}
										</div>
									</div>
								</c:if>

								<%-- Submission is handled via fetch() in JS below; no native form POST --%>
									<div class="form-card">
										<form id="add-artist-form" novalidate>

											<div class="form-grid">

												<%-- ── id (Artist.id — the @Field("id") business key, not mongoId) ──
													--%>
													<div class="form-group">
														<label class="form-label" for="id">Artist ID <span
																class="required">*</span></label>
														<input id="id" name="id" type="text" class="form-input"
															placeholder="e.g. artist_001" required autocomplete="off" />
													</div>

													<%-- ── name (@NotBlank) ── --%>
														<div class="form-group">
															<label class="form-label" for="name">Stage / Full Name <span
																	class="required">*</span></label>
															<input id="name" name="name" type="text" class="form-input"
																placeholder="e.g. Billie Eilish" required
																autocomplete="name" />
														</div>

														<%-- ── type (ArtistType enum: SOLO, DUO, BAND) ── --%>
															<div class="form-group">
																<label class="form-label" for="type">Artist Type</label>
																<select id="type" name="type" class="form-select">
																	<option value="" disabled selected>Select a type…
																	</option>
																	<option value="solo">Solo</option>
																	<option value="duo">Duo</option>
																	<option value="band">Band</option>
																</select>
															</div>

															<%-- ── country (@NotBlank) ── --%>
																<div class="form-group">
																	<label class="form-label" for="country">Country
																		<span class="required">*</span></label>
																	<input id="country" name="country" type="text"
																		class="form-input"
																		placeholder="e.g. United States" required
																		autocomplete="country-name" />
																</div>

																<%-- ── artist image upload ── --%>
																	<div class="form-group full">
																		<span class="form-label">Artist Photo</span>
																		<label class="file-drop-zone"
																			id="file-drop-zone" for="imageFile">
																			<div class="file-drop-inner"
																				id="file-drop-inner">
																				<svg class="file-drop-icon" width="32"
																					height="32" viewBox="0 0 24 24"
																					fill="none" stroke="currentColor"
																					stroke-width="1.5"
																					stroke-linecap="round"
																					stroke-linejoin="round"
																					aria-hidden="true">
																					<rect x="3" y="3" width="18"
																						height="18" rx="4" />
																					<circle cx="8.5" cy="8.5" r="1.5" />
																					<polyline
																						points="21 15 16 10 5 21" />
																				</svg>
																				<span class="file-drop-text">Drop an
																					image or <u>browse</u></span>
																				<span class="file-drop-hint">JPG, PNG,
																					WEBP · max 5 MB</span>
																			</div>
																			<img id="image-preview"
																				class="image-preview hidden"
																				alt="Artist photo preview" />
																			<input id="imageFile" name="imageFile"
																				type="file" accept="image/*"
																				class="file-input-hidden" />
																		</label>
																		<span class="file-name-label"
																			id="file-name-label"></span>
																	</div>

																	<%-- ── genre (Set<String> — each checked checkbox
																		posts a value under the same
																		name "genre"; Spring binds repeated params into
																		the Set automatically) ──
																		--%>
																		<div class="form-group full">
																			<span class="form-label">Genres</span>
																			<div class="genre-chips" id="genre-chips"
																				role="group" aria-label="Select genres">
																				<c:choose>
																					<c:when test="${not empty genres}">
																						<c:forEach var="g"
																							items="${genres}">
																							<label class="genre-chip">
																								<input type="checkbox"
																									name="genre"
																									value="${g}" />
																								<span>${g}</span>
																							</label>
																						</c:forEach>
																					</c:when>
																					<c:otherwise>
																						<%-- Fallback hard-coded list
																							--%>
																							<c:forEach var="g"
																								items="Pop,Rock,Hip-Hop,R&B,Electronic,Jazz,Classical,Country,Indie,Metal,Folk,Other">
																								<label
																									class="genre-chip">
																									<input
																										type="checkbox"
																										name="genre"
																										value="${g}" />
																									<span>${g}</span>
																								</label>
																							</c:forEach>
																					</c:otherwise>
																				</c:choose>
																			</div>
																		</div>

																		<div class="form-divider"></div>

																		<%-- ── bio ── --%>
																			<div class="form-group full">
																				<label class="form-label"
																					for="bio">Short Bio</label>
																				<textarea id="bio" name="bio"
																					class="form-textarea"
																					placeholder="A brief description of the artist, their style, and career highlights…"></textarea>
																			</div>

																			<%-- ── Actions ── --%>
																				<div class="form-actions">
																					<button type="submit"
																						class="btn-submit"
																						id="submit-btn">
																						<svg width="16" height="16"
																							viewBox="0 0 24 24"
																							fill="none"
																							stroke="currentColor"
																							stroke-width="2.2"
																							stroke-linecap="round"
																							stroke-linejoin="round"
																							aria-hidden="true">
																							<circle cx="12" cy="8"
																								r="4" />
																							<path
																								d="M20 21a8 8 0 1 0-16 0" />
																							<line x1="19" y1="8" x2="19"
																								y2="14" />
																							<line x1="16" y1="11"
																								x2="22" y2="11" />
																						</svg>
																						Register Artist
																					</button>
																					<a href="/"
																						class="btn-cancel">Cancel</a>
													</div>
											</div><%-- /form-grid --%>
										</form>
									</div><%-- /form-card --%>
						</div>
					</main>

					<footer>
						<div class="wrapper">
							<p>Resonance Music Artist Registry &nbsp;&middot;&nbsp; <a href="#">API Docs</a>
								&nbsp;&middot;&nbsp; <a href="#">Privacy</a></p>
						</div>
					</footer>

					<script>
						/* ── Nav scroll ── */
						const nav = document.getElementById('main-nav');
						window.addEventListener('scroll', () => nav.classList.toggle('scrolled', window.scrollY > 20), {passive: true});

						/* ── Register dropdown toggle ── */
						const registerDropdown = document.getElementById('register-dropdown');
						const registerToggle = document.getElementById('register-toggle');
						registerToggle.addEventListener('click', (e) => {
							e.stopPropagation();
							const isOpen = registerDropdown.classList.toggle('open');
							registerToggle.setAttribute('aria-expanded', isOpen);
						});
						document.addEventListener('click', () => {
							registerDropdown.classList.remove('open');
							registerToggle.setAttribute('aria-expanded', 'false');
						});
						registerDropdown.addEventListener('click', e => e.stopPropagation());

						/* ── Image file upload: preview + drag-and-drop ── */
						const fileInput = document.getElementById('imageFile');
						const dropZone = document.getElementById('file-drop-zone');
						const dropInner = document.getElementById('file-drop-inner');
						const preview = document.getElementById('image-preview');
						const fileLabel = document.getElementById('file-name-label');

						function applyPreview(file) {
							if (!file || !file.type.startsWith('image/')) return;
							const url = URL.createObjectURL(file);
							preview.src = url;
							preview.classList.remove('hidden');
							dropInner.classList.add('hidden');
							fileLabel.textContent = file.name;
						}

						fileInput.addEventListener('change', () => {
							if (fileInput.files[0]) applyPreview(fileInput.files[0]);
						});

						dropZone.addEventListener('dragover', (e) => {e.preventDefault(); dropZone.classList.add('drag-over');});
						dropZone.addEventListener('dragleave', () => dropZone.classList.remove('drag-over'));
						dropZone.addEventListener('drop', (e) => {
							e.preventDefault();
							dropZone.classList.remove('drag-over');
							const file = e.dataTransfer.files[0];
							if (file) {
								/* Assign to the real file input so FormData picks it up */
								const dt = new DataTransfer();
								dt.items.add(file);
								fileInput.files = dt.files;
								applyPreview(file);
							}
						});

						/* ── Form submission via fetch (multipart/form-data) → redirect on 201 ── */
						const form = document.getElementById('add-artist-form');
						const submitBtn = document.getElementById('submit-btn');

						form.addEventListener('submit', async (e) => {
							e.preventDefault();

							const idEl = document.getElementById('id');
							const nameEl = document.getElementById('name');
							const countryEl = document.getElementById('country');

							/* Client-side required field validation */
							const fields = [
								{el: idEl, val: idEl.value.trim()},
								{el: nameEl, val: nameEl.value.trim()},
								{el: countryEl, val: countryEl.value.trim()},
							];
							const invalid = fields.filter(f => !f.val);
							if (invalid.length) {
								invalid.forEach(({el}) => {
									el.style.borderColor = 'rgba(232,48,42,0.65)';
									el.style.boxShadow = '0 0 0 3px rgba(232,48,42,0.12)';
									el.addEventListener('input', () => {el.style.borderColor = ''; el.style.boxShadow = '';}, {once: true});
								});
								invalid[0].el.focus();
								return;
							}

							/* Build Artist JSON part matching the Artist DTO */
							const genreCheckboxes = form.querySelectorAll('input[name="genre"]:checked');
							const artistData = {
								id: idEl.value.trim(),
								name: nameEl.value.trim(),
								type: document.getElementById('type').value || null,
								country: countryEl.value.trim(),
								bio: document.getElementById('bio').value.trim() || null,
								genre: Array.from(genreCheckboxes).map(cb => cb.value)
							};

							/* Build multipart body: "artist" part (JSON blob) + "file" part (image) */
							const formData = new FormData();
							formData.append('artist', new Blob([JSON.stringify(artistData)], {type: 'application/json'}));
							const imageFile = fileInput.files[0];
							if (imageFile) {
								formData.append('file', imageFile);
							} else {
								showError('Please select an artist photo before submitting.');
								return;
							}

							/* Loading state */
							submitBtn.disabled = true;
							submitBtn.innerHTML = `
      <svg style="animation:spin .7s linear infinite" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 12a9 9 0 1 1-6.219-8.56"/>
      </svg>
      Registering…`;

							try {
								/* Do NOT set Content-Type — the browser sets the correct multipart boundary */
								const response = await fetch('${pageContext.request.contextPath}/api/artists/send', {
									method: 'POST',
									body: formData
								});

								if (response.status === 201) {
									const savedArtist = await response.json();
									window.location.href = '${pageContext.request.contextPath}/artist-details/' + savedArtist.mongoId;
								} else {
									const msg = await response.text();
									showError(msg || 'Something went wrong. Please try again.');
									resetButton();
								}
							} catch (err) {
								showError('Network error. Please check your connection and try again.');
								resetButton();
							}
						});

						function resetButton() {
							submitBtn.disabled = false;
							submitBtn.innerHTML = `
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="8" r="4"/><path d="M20 21a8 8 0 1 0-16 0"/>
        <line x1="19" y1="8" x2="19" y2="14"/><line x1="16" y1="11" x2="22" y2="11"/>
      </svg>
      Register Artist`;
						}

						function showError(msg) {
							/* Remove any existing error banner first */
							const existing = document.getElementById('fetch-error');
							if (existing) existing.remove();
							const banner = document.createElement('div');
							banner.id = 'fetch-error';
							banner.className = 'alert alert-error';
							banner.style.cssText = 'max-width:640px;margin:0 auto 1.5rem;';
							banner.innerHTML = `
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
      </svg>
      ${msg}`;
							document.querySelector('.form-card').insertAdjacentElement('beforebegin', banner);
							banner.scrollIntoView({behavior: 'smooth', block: 'center'});
						}
					</script>

					<style>
						@keyframes spin {
							to {
								transform: rotate(360deg);
							}
						}
					</style>

		</body>

		</html>