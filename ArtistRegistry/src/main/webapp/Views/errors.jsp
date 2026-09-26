<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
			<!DOCTYPE html>
			<html lang="en">

			<head>
				<meta charset="UTF-8" />
				<meta name="viewport" content="width=device-width, initial-scale=1.0" />
				<title>Error — Resonance</title>
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
						--grad-text: linear-gradient(100deg, var(--red-light) 0%, #c084fc 50%, var(--blue-light) 100%);
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
						display: flex;
						flex-direction: column;
						min-height: 100vh;
					}

					/* ── Background canvas ── */
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
						background-image:
							linear-gradient(rgba(255, 255, 255, 0.018) 1px, transparent 1px),
							linear-gradient(90deg, rgba(255, 255, 255, 0.018) 1px, transparent 1px);
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

					/* ── Nav ── */
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

					.nav-links .btn-home {
						background: linear-gradient(135deg, rgba(232, 48, 42, 0.14), rgba(155, 26, 21, 0.14));
						border: 1px solid rgba(232, 48, 42, 0.32);
						color: var(--red-light);
						display: flex;
						align-items: center;
						gap: 6px;
					}

					.nav-links .btn-home:hover {
						background: linear-gradient(135deg, rgba(232, 48, 42, 0.26), rgba(155, 26, 21, 0.26));
						border-color: rgba(232, 48, 42, 0.6);
						color: #fff;
						transform: translateY(-1px);
						box-shadow: 0 4px 20px rgba(232, 48, 42, 0.18);
					}

					/* ── Error stage ── */
					main {
						flex: 1;
						display: flex;
						align-items: center;
						justify-content: center;
						padding: 4rem 2rem;
					}

					.error-stage {
						position: relative;
						z-index: 1;
						display: flex;
						flex-direction: column;
						align-items: center;
						text-align: center;
						max-width: 660px;
						width: 100%;
					}

					/* Glowing code badge */
					.error-code {
						font-family: 'Cormorant Garamond', serif;
						font-size: clamp(6rem, 20vw, 10rem);
						font-weight: 300;
						line-height: 1;
						letter-spacing: -0.02em;
						background: var(--grad-text);
						-webkit-background-clip: text;
						background-clip: text;
						-webkit-text-fill-color: transparent;
						user-select: none;
						margin-bottom: 0.2em;
						/* Subtle glow behind the text */
						filter: drop-shadow(0 0 60px rgba(232, 48, 42, 0.28));
						opacity: 0;
						transform: translateY(24px);
						transition: opacity .8s ease, transform .8s ease;
					}

					.error-code.in {
						opacity: 1;
						transform: translateY(0);
					}

					/* Horizontal rule with gradient */
					.error-rule {
						width: 64px;
						height: 2px;
						background: var(--grad);
						border-radius: 2px;
						margin: 0 auto 1.6rem;
						opacity: 0;
						transform: scaleX(0);
						transition: opacity .6s .25s ease, transform .6s .25s ease;
					}

					.error-rule.in {
						opacity: 1;
						transform: scaleX(1);
					}

					/* Title */
					.error-title {
						font-family: 'Syne', sans-serif;
						font-size: clamp(1.05rem, 3.5vw, 1.35rem);
						font-weight: 700;
						letter-spacing: 0.18em;
						text-transform: uppercase;
						color: var(--text-primary);
						margin-bottom: 1rem;
						opacity: 0;
						transform: translateY(14px);
						transition: opacity .7s .3s ease, transform .7s .3s ease;
					}

					.error-title.in {
						opacity: 1;
						transform: translateY(0);
					}

					/* Message card — mirrors .search-panel glass style */
					.error-card {
						width: 100%;
						background: rgba(255, 255, 255, 0.048);
						backdrop-filter: blur(28px) saturate(160%);
						border: 1px solid rgba(255, 255, 255, 0.10);
						border-radius: 18px;
						padding: 1.6rem 2rem;
						box-shadow: 0 4px 40px rgba(0, 0, 0, 0.35), inset 0 1px 0 rgba(255, 255, 255, 0.08);
						margin-bottom: 2rem;
						opacity: 0;
						transform: translateY(18px);
						transition: opacity .75s .45s ease, transform .75s .45s ease;
					}

					.error-card.in {
						opacity: 1;
						transform: translateY(0);
					}

					/* Label above the message */
					.card-label {
						font-family: 'Syne', sans-serif;
						font-size: 0.65rem;
						font-weight: 600;
						letter-spacing: 0.24em;
						text-transform: uppercase;
						color: var(--text-muted);
						display: flex;
						align-items: center;
						gap: 8px;
						margin-bottom: 0.75rem;
					}

					.card-label::before {
						content: '';
						display: inline-block;
						width: 6px;
						height: 6px;
						border-radius: 50%;
						background: var(--red-light);
						box-shadow: 0 0 8px var(--red-light);
						animation: pulse-dot 2s ease-in-out infinite;
					}

					@keyframes pulse-dot {

						0%,
						100% {
							opacity: 1;
							transform: scale(1);
						}

						50% {
							opacity: .5;
							transform: scale(0.7);
						}
					}

					/* The actual error message text */
					.error-message {
						font-family: 'DM Sans', sans-serif;
						font-size: 1rem;
						color: var(--text-secondary);
						line-height: 1.65;
						word-break: break-word;
					}

					/* Fallback when no errorMessage attribute is set */
					.error-message.generic {
						color: var(--text-muted);
						font-style: italic;
					}

					/* Action buttons */
					.error-actions {
						display: flex;
						flex-wrap: wrap;
						gap: 0.75rem;
						justify-content: center;
						opacity: 0;
						transform: translateY(12px);
						transition: opacity .7s .6s ease, transform .7s .6s ease;
					}

					.error-actions.in {
						opacity: 1;
						transform: translateY(0);
					}

					.btn-primary {
						background: linear-gradient(135deg, #e8302a 0%, #9b1a15 100%);
						color: #fff;
						font-family: 'Syne', sans-serif;
						font-size: 0.82rem;
						font-weight: 700;
						letter-spacing: 0.1em;
						text-transform: uppercase;
						text-decoration: none;
						border: none;
						border-radius: 11px;
						padding: 0.82rem 1.6rem;
						cursor: pointer;
						display: inline-flex;
						align-items: center;
						gap: 8px;
						position: relative;
						overflow: hidden;
						transition: transform 0.22s, box-shadow 0.22s;
					}

					.btn-primary::after {
						content: '';
						position: absolute;
						top: 0;
						left: -100%;
						width: 60%;
						height: 100%;
						background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.22), transparent);
						transition: left 0.45s ease;
					}

					.btn-primary:hover::after {
						left: 140%;
					}

					.btn-primary:hover {
						transform: translateY(-2px);
						box-shadow: 0 6px 28px rgba(232, 48, 42, 0.38);
					}

					.btn-ghost {
						background: transparent;
						color: var(--text-secondary);
						font-family: 'Syne', sans-serif;
						font-size: 0.82rem;
						font-weight: 600;
						letter-spacing: 0.1em;
						text-transform: uppercase;
						text-decoration: none;
						border: 1px solid rgba(255, 255, 255, 0.12);
						border-radius: 11px;
						padding: 0.82rem 1.6rem;
						cursor: pointer;
						display: inline-flex;
						align-items: center;
						gap: 8px;
						transition: color 0.22s, background 0.22s, border-color 0.22s, transform 0.22s;
					}

					.btn-ghost:hover {
						color: var(--text-primary);
						background: rgba(255, 255, 255, 0.06);
						border-color: rgba(255, 255, 255, 0.22);
						transform: translateY(-2px);
					}

					/* ── Footer ── */
					footer {
						position: relative;
						z-index: 1;
						border-top: 1px solid rgba(255, 255, 255, 0.06);
						padding: 1.4rem 0;
						text-align: center;
						color: var(--text-muted);
						font-size: 0.82rem;
					}

					footer a {
						color: var(--text-muted);
						text-decoration: none;
						transition: color .2s;
					}

					footer a:hover {
						color: var(--text-secondary);
					}
				</style>
			</head>

			<body>

				<%-- Animated background ── same as index.jsp --%>
					<div class="bg-canvas" aria-hidden="true">
						<div class="orb orb-1"></div>
						<div class="orb orb-2"></div>
						<div class="orb orb-3"></div>
						<div class="orb orb-4"></div>
					</div>
					<div class="grid-lines" aria-hidden="true"></div>

					<%-- Navigation ── identical markup / class structure to index.jsp --%>
						<nav id="main-nav" aria-label="Main navigation">
							<div class="wrapper">
								<div class="nav-inner">
									<a href="${pageContext.request.contextPath}/" class="logo"
										aria-label="Resonance home">
										<div class="logo-icon" aria-hidden="true">
											<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
												<path
													d="M12 3a9 9 0 1 0 9 9A9 9 0 0 0 12 3zm0 16a7 7 0 1 1 7-7 7 7 0 0 1-7 7zm1-11h-2v5l4.28 2.54.72-1.21-3-1.79z" />
											</svg>
										</div>
										Reso<span>nance</span>
									</a>
									<ul class="nav-links">
										<li><a href="${pageContext.request.contextPath}/library">Library</a></li>
										<li><a href="${pageContext.request.contextPath}/" class="btn-home">
												<svg width="13" height="13" viewBox="0 0 24 24" fill="none"
													stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
													stroke-linejoin="round" aria-hidden="true">
													<path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
													<polyline points="9 22 9 12 15 12 15 22" />
												</svg>
												Home
											</a></li>
									</ul>
								</div>
							</div>
						</nav>

						<%-- ── Error content ── --%>
							<main>
								<div class="error-stage" role="main" aria-labelledby="error-title">

									<%-- Derive a meaningful HTTP status code. Spring Boot puts the status in
										the "jakarta.servlet.error.status_code" attribute when forwarding to an error
										page via web.xml / ErrorController. Fall back to a generic indicator when it is
										not present. --%>
										<c:if test="${empty statusCode}">
											<%-- Legacy Servlet API attribute name --%>
												<c:set var="statusCode"
													value="${requestScope['javax.servlet.error.status_code']}" />
										</c:if>

										<div class="error-code" id="error-code"
											aria-label="Error ${not empty statusCode ? statusCode : ''}">
											<c:choose>
												<c:when test="${not empty statusCode}">${statusCode}</c:when>
												<c:otherwise>Oops</c:otherwise>
											</c:choose>
										</div>

										<div class="error-rule" id="error-rule"></div>

										<h1 class="error-title" id="error-title">
											<c:choose>
												<c:when test="${statusCode == 404}">Page Not Found</c:when>
												<c:when test="${statusCode == 403}">Access Denied</c:when>
												<c:when test="${statusCode == 500}">Internal Server Error</c:when>
												<c:otherwise>Something Went Wrong</c:otherwise>
											</c:choose>
										</h1>

										<%-- Main message card. The "errorMessage" model attribute is set by the Spring
											MVC controller / exception handler and forwarded to this view. When absent,
											show a generic fallback. --%>
											<div class="error-card" id="error-card">
												<div class="card-label">Error Detail</div>
												<p class="error-message ${empty errorMessage ? 'generic' : ''}">
													<c:choose>
														<c:when test="${not empty errorMessage}">
															<c:out value="${errorMessage}" />
														</c:when>
														<c:otherwise>
															An unexpected error occurred. Please try again or return
															home.
														</c:otherwise>
													</c:choose>
												</p>
											</div>

											<div class="error-actions" id="error-actions">
												<a href="${pageContext.request.contextPath}/" class="btn-primary">
													<svg width="14" height="14" viewBox="0 0 24 24" fill="none"
														stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
														stroke-linejoin="round" aria-hidden="true">
														<path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
														<polyline points="9 22 9 12 15 12 15 22" />
													</svg>
													Back to Home
												</a>
												<a href="javascript:history.back()" class="btn-ghost">
													<svg width="14" height="14" viewBox="0 0 24 24" fill="none"
														stroke="currentColor" stroke-width="2" stroke-linecap="round"
														stroke-linejoin="round" aria-hidden="true">
														<polyline points="15 18 9 12 15 6" />
													</svg>
													Go Back
												</a>
											</div>

								</div>
							</main>

							<footer>
								<div class="wrapper">
									<p>Resonance Music Artist Registry &nbsp;&middot;&nbsp; <a href="#">API Docs</a>
										&nbsp;&middot;&nbsp; <a href="#">Privacy</a></p>
								</div>
							</footer>

							<script>
								/* ── Entrance animations ── */
								requestAnimationFrame(() => {
									['error-code', 'error-rule', 'error-title', 'error-card', 'error-actions'].forEach((id, i) => {
										const el = document.getElementById(id);
										if (!el) return;
										setTimeout(() => el.classList.add('in'), i * 120);
									});
								});

								/* ── Scroll nav tint ── */
								const nav = document.getElementById('main-nav');
								window.addEventListener('scroll', () => {
									nav.style.background = window.scrollY > 20
										? 'rgba(8,3,5,0.82)'
										: 'rgba(8,3,5,0.45)';
								}, {passive: true});
							</script>

			</body>

			</html>