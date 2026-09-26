<%@ page contentType="text/html;charset=UTF-8" language="java" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<!DOCTYPE html>
		<html lang="en">

		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title>Resonance — Create Account</title>
			<link rel="icon" href="/resources/favicon.ico" type="image/x-icon">
			<link rel="preconnect" href="https://fonts.googleapis.com">
			<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
			<link
				href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=Inter:wght@300;400;500&display=swap"
				rel="stylesheet">

			<style>
				*,
				*::before,
				*::after {
					box-sizing: border-box;
					margin: 0;
					padding: 0;
				}

				:root {
					--ink: #07080f;
					--deep: #0d0f1c;
					--mid: #12152a;
					--fog: #1c2040;
					--muted: rgba(255, 255, 255, 0.35);
					--subtle: rgba(255, 255, 255, 0.08);
					--iris: #7b6cff;
					--violet: #a855f7;
					--rose: #f43f8e;
					--gold: #f5c842;
					--cyan: #38d9f5;
					--text: #e8eaf6;
					--text-dim: rgba(232, 234, 246, 0.55);
				}

				html,
				body {
					height: 100%;
					width: 100%;
					background: var(--ink);
					font-family: 'Inter', sans-serif;
					color: var(--text);
					overflow: hidden;
				}

				/* ── SCENE ─────────────────────────────────────────────── */
				.scene {
					position: relative;
					width: 100vw;
					height: 100vh;
					display: flex;
					align-items: center;
					justify-content: center;
					overflow: hidden;
				}

				.scene::before {
					content: '';
					position: absolute;
					inset: 0;
					background:
						radial-gradient(ellipse 80% 60% at 20% 50%, #1a1040 0%, transparent 60%),
						radial-gradient(ellipse 60% 80% at 80% 30%, #0a0d22 0%, transparent 55%),
						radial-gradient(ellipse 50% 50% at 50% 100%, #120820 0%, transparent 60%),
						linear-gradient(160deg, #0c0e1e 0%, #07080f 100%);
					z-index: 0;
				}

				/* ── AMBIENT ORBS ───────────────────────────────────────── */
				.orb {
					position: absolute;
					border-radius: 50%;
					filter: blur(60px);
					pointer-events: none;
					z-index: 1;
				}

				.orb-1 {
					width: 780px;
					height: 780px;
					background: radial-gradient(circle, rgba(123, 108, 255, 0.48) 0%, rgba(109, 95, 255, 0.18) 45%, transparent 70%);
					top: -200px;
					left: -180px;
					animation: drift1 12s ease-in-out infinite alternate;
				}

				.orb-2 {
					width: 640px;
					height: 640px;
					background: radial-gradient(circle, rgba(244, 63, 142, 0.42) 0%, rgba(236, 72, 153, 0.16) 45%, transparent 70%);
					bottom: -140px;
					right: -100px;
					animation: drift2 15s ease-in-out infinite alternate;
				}

				.orb-3 {
					width: 500px;
					height: 500px;
					background: radial-gradient(circle, rgba(56, 217, 245, 0.30) 0%, rgba(56, 217, 245, 0.10) 45%, transparent 70%);
					top: 35%;
					left: 55%;
					animation: drift3 18s ease-in-out infinite alternate;
				}

				.orb-4 {
					width: 420px;
					height: 420px;
					background: radial-gradient(circle, rgba(168, 85, 247, 0.35) 0%, rgba(168, 85, 247, 0.10) 45%, transparent 70%);
					top: 55%;
					left: 15%;
					animation: drift4 20s ease-in-out infinite alternate;
				}

				@keyframes drift1 {
					0% { transform: translate(0, 0) scale(1); }
					50% { transform: translate(120px, 60px) scale(1.18); }
					100% { transform: translate(60px, 140px) scale(1.08); }
				}

				@keyframes drift2 {
					0% { transform: translate(0, 0) scale(1); }
					50% { transform: translate(-90px, -80px) scale(1.15); }
					100% { transform: translate(-140px, -40px) scale(1.22); }
				}

				@keyframes drift3 {
					0% { transform: translate(0, 0) scale(1); }
					40% { transform: translate(-100px, 70px) scale(1.2); }
					100% { transform: translate(-60px, -80px) scale(0.85); }
				}

				@keyframes drift4 {
					0% { transform: translate(0, 0) scale(1); }
					60% { transform: translate(80px, -60px) scale(1.25); }
					100% { transform: translate(140px, 40px) scale(0.9); }
				}

				/* ── VINYL RECORD ───────────────────────────────────────── */
				.vinyl-wrap {
					position: absolute;
					right: -80px;
					top: 50%;
					transform: translateY(-52%);
					z-index: 2;
					pointer-events: none;
				}

				.vinyl {
					width: 540px;
					height: 540px;
					border-radius: 50%;
					position: relative;
					animation: spin 28s linear infinite;
					filter: drop-shadow(0 0 60px rgba(123, 108, 255, 0.25)) drop-shadow(0 0 20px rgba(244, 63, 142, 0.15));
				}

				@keyframes spin {
					to { transform: rotate(360deg); }
				}

				.vinyl svg {
					width: 100%;
					height: 100%;
				}

				.vinyl-light {
					position: absolute;
					top: 50%;
					left: 50%;
					width: 600px;
					height: 2px;
					transform-origin: 0 50%;
					background: linear-gradient(90deg, transparent, rgba(245, 200, 66, 0.04) 30%, rgba(168, 85, 247, 0.08) 60%, transparent);
					filter: blur(4px);
					animation: lightSweep 28s linear infinite;
					z-index: 3;
					pointer-events: none;
				}

				@keyframes lightSweep {
					from { transform: rotate(0deg); opacity: 0.6; }
					25% { opacity: 1; }
					to { transform: rotate(360deg); opacity: 0.6; }
				}

				/* ── LIQUID GLASS CARD ──────────────────────────────────── */
				.glass-card {
					position: relative;
					z-index: 10;
					width: 440px;
					padding: 44px 44px 40px;
					border-radius: 28px;
					background:
						linear-gradient(145deg,
							rgba(255, 255, 255, 0.055) 0%,
							rgba(255, 255, 255, 0.02) 40%,
							rgba(123, 108, 255, 0.04) 70%,
							rgba(244, 63, 142, 0.025) 100%);
					backdrop-filter: blur(32px) saturate(1.6) brightness(1.05);
					-webkit-backdrop-filter: blur(32px) saturate(1.6) brightness(1.05);
					border: 1px solid transparent;
					background-clip: padding-box;
					box-shadow:
						0 0 0 1px rgba(255, 255, 255, 0.09),
						inset 0 1px 0 rgba(255, 255, 255, 0.14),
						inset 0 -1px 0 rgba(0, 0, 0, 0.25),
						0 32px 80px rgba(0, 0, 0, 0.55),
						0 0 0 1.5px rgba(123, 108, 255, 0.18),
						0 0 40px rgba(123, 108, 255, 0.06);
					animation: liquidShift 8s ease-in-out infinite alternate;
				}

				@keyframes liquidShift {
					0% { box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.09), inset 0 1px 0 rgba(255, 255, 255, 0.14), inset 0 -1px 0 rgba(0, 0, 0, 0.25), 0 32px 80px rgba(0, 0, 0, 0.55), 0 0 0 1.5px rgba(123, 108, 255, 0.22), 0 0 40px rgba(123, 108, 255, 0.08); }
					33% { box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.09), inset 0 1px 0 rgba(255, 255, 255, 0.14), inset 0 -1px 0 rgba(0, 0, 0, 0.25), 0 32px 80px rgba(0, 0, 0, 0.55), 0 0 0 1.5px rgba(244, 63, 142, 0.22), 0 0 40px rgba(244, 63, 142, 0.08); }
					66% { box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.09), inset 0 1px 0 rgba(255, 255, 255, 0.14), inset 0 -1px 0 rgba(0, 0, 0, 0.25), 0 32px 80px rgba(0, 0, 0, 0.55), 0 0 0 1.5px rgba(56, 217, 245, 0.18), 0 0 40px rgba(56, 217, 245, 0.06); }
					100% { box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.09), inset 0 1px 0 rgba(255, 255, 255, 0.14), inset 0 -1px 0 rgba(0, 0, 0, 0.25), 0 32px 80px rgba(0, 0, 0, 0.55), 0 0 0 1.5px rgba(168, 85, 247, 0.22), 0 0 40px rgba(168, 85, 247, 0.08); }
				}

				.glass-card::before {
					content: '';
					position: absolute;
					inset: 0;
					border-radius: 28px;
					background: linear-gradient(125deg,
							rgba(255, 255, 255, 0.09) 0%,
							rgba(168, 85, 247, 0.06) 25%,
							rgba(56, 217, 245, 0.04) 50%,
							rgba(244, 63, 142, 0.06) 75%,
							rgba(255, 255, 255, 0.04) 100%);
					pointer-events: none;
					animation: iridescent 8s ease-in-out infinite alternate;
				}

				@keyframes iridescent {
					0% { opacity: 0.6; filter: hue-rotate(0deg); }
					50% { opacity: 1; filter: hue-rotate(30deg); }
					100% { opacity: 0.7; filter: hue-rotate(-20deg); }
				}

				.glass-card::after {
					content: '';
					position: absolute;
					top: 0;
					left: 12px;
					right: 12px;
					height: 1px;
					background: linear-gradient(90deg,
							transparent,
							rgba(255, 255, 255, 0.45) 30%,
							rgba(168, 85, 247, 0.6) 50%,
							rgba(255, 255, 255, 0.45) 70%,
							transparent);
					border-radius: 50%;
					animation: topShimmer 8s ease-in-out infinite alternate;
				}

				@keyframes topShimmer {
					0% { opacity: 0.5; filter: hue-rotate(0deg); }
					100% { opacity: 0.9; filter: hue-rotate(40deg); }
				}

				/* ── LOGO / WORDMARK ────────────────────────────────────── */
				.brand {
					display: flex;
					align-items: center;
					gap: 10px;
					margin-bottom: 32px;
				}

				.brand-icon {
					width: 32px;
					height: 32px;
					flex-shrink: 0;
				}

				.brand-name {
					font-family: 'Syne', sans-serif;
					font-size: 20px;
					font-weight: 700;
					letter-spacing: 0.06em;
					text-transform: uppercase;
					background: linear-gradient(110deg, #c4bfff 0%, #a78bfa 50%, #f0abfc 100%);
					-webkit-background-clip: text;
					-webkit-text-fill-color: transparent;
					background-clip: text;
				}

				/* ── HEADINGS ───────────────────────────────────────────── */
				.login-heading {
					font-family: 'Syne', sans-serif;
					font-size: 30px;
					font-weight: 800;
					line-height: 1.1;
					letter-spacing: -0.02em;
					color: var(--text);
					margin-bottom: 6px;
				}

				.login-sub {
					font-size: 14px;
					font-weight: 300;
					color: var(--text-dim);
					margin-bottom: 32px;
					letter-spacing: 0.01em;
				}

				/* ── FORM ELEMENTS ──────────────────────────────────────── */
				.field {
					margin-bottom: 16px;
				}

				label {
					display: block;
					font-size: 11px;
					font-weight: 500;
					letter-spacing: 0.1em;
					text-transform: uppercase;
					color: rgba(255, 255, 255, 0.4);
					margin-bottom: 8px;
				}

				input[type="text"],
				input[type="password"],
				input[type="email"] {
					width: 100%;
					height: 48px;
					padding: 0 16px;
					background: rgba(255, 255, 255, 0.05);
					border: 1px solid rgba(255, 255, 255, 0.10);
					border-radius: 12px;
					color: var(--text);
					font-family: 'Inter', sans-serif;
					font-size: 14px;
					font-weight: 400;
					outline: none;
					transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
					-webkit-backdrop-filter: blur(8px);
					backdrop-filter: blur(8px);
				}

				input::placeholder {
					color: rgba(255, 255, 255, 0.22);
				}

				input:focus {
					border-color: rgba(123, 108, 255, 0.55);
					background: rgba(123, 108, 255, 0.06);
					box-shadow:
						0 0 0 3px rgba(123, 108, 255, 0.12),
						inset 0 1px 0 rgba(255, 255, 255, 0.06);
				}

				input.field-invalid {
					border-color: rgba(244, 63, 142, 0.55);
				}

				.hint {
					font-size: 11px;
					color: rgba(255, 255, 255, 0.3);
					margin-top: 6px;
					letter-spacing: 0.01em;
				}

				.hint.mismatch {
					color: rgba(244, 63, 142, 0.85);
				}

				/* ── ERROR MESSAGE ──────────────────────────────────────── */
				.error-msg {
					display: flex;
					align-items: center;
					gap: 8px;
					padding: 12px 14px;
					background: rgba(244, 63, 142, 0.08);
					border: 1px solid rgba(244, 63, 142, 0.22);
					border-radius: 10px;
					font-size: 13px;
					color: rgba(244, 63, 142, 0.9);
					margin-bottom: 20px;
					display: none;
				}

				.error-msg.show {
					display: flex;
				}

				.error-msg svg {
					flex-shrink: 0;
				}

				/* ── SUCCESS MESSAGE ─────────────────────────────────────── */
				.success-msg {
					display: flex;
					align-items: center;
					gap: 8px;
					padding: 12px 14px;
					background: rgba(56, 217, 245, 0.07);
					border: 1px solid rgba(56, 217, 245, 0.22);
					border-radius: 10px;
					font-size: 13px;
					color: rgba(56, 217, 245, 0.9);
					margin-bottom: 20px;
					display: none;
				}

				.success-msg.show {
					display: flex;
				}

				.success-msg svg {
					flex-shrink: 0;
				}

				/* ── SUBMIT BUTTON ──────────────────────────────────────── */
				.btn-signin {
					width: 100%;
					height: 52px;
					margin-top: 8px;
					border: none;
					border-radius: 14px;
					font-family: 'Syne', sans-serif;
					font-size: 15px;
					font-weight: 700;
					letter-spacing: 0.05em;
					text-transform: uppercase;
					cursor: pointer;
					position: relative;
					overflow: hidden;
					background: linear-gradient(135deg, #6d5fff 0%, #a855f7 50%, #ec4899 100%);
					color: #fff;
					box-shadow:
						0 0 0 1px rgba(255, 255, 255, 0.12) inset,
						0 8px 32px rgba(109, 95, 255, 0.35),
						0 2px 8px rgba(0, 0, 0, 0.3);
					transition: transform 0.15s, box-shadow 0.15s, filter 0.15s;
				}

				.btn-signin::before {
					content: '';
					position: absolute;
					inset: 0;
					background: linear-gradient(135deg, rgba(255, 255, 255, 0.14) 0%, transparent 50%);
					pointer-events: none;
				}

				.btn-signin::after {
					content: '';
					position: absolute;
					top: -50%;
					left: -60%;
					width: 50%;
					height: 200%;
					background: rgba(255, 255, 255, 0.18);
					transform: skewX(-20deg);
					transition: left 0.4s ease;
				}

				.btn-signin:hover::after {
					left: 120%;
				}

				.btn-signin:hover {
					filter: brightness(1.08);
					transform: translateY(-1px);
					box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.12) inset, 0 12px 40px rgba(109, 95, 255, 0.45), 0 2px 8px rgba(0, 0, 0, 0.3);
				}

				.btn-signin:active {
					transform: translateY(0);
					filter: brightness(0.95);
				}

				.btn-signin:disabled {
					opacity: 0.6;
					cursor: not-allowed;
					transform: none;
				}

				/* ── FOOTER LINK ────────────────────────────────────────── */
				.footer-text {
					text-align: center;
					font-size: 13px;
					color: var(--text-dim);
					margin-top: 24px;
				}

				.footer-text a {
					color: rgba(168, 85, 247, 0.85);
					text-decoration: none;
					font-weight: 500;
					transition: color 0.2s;
				}

				.footer-text a:hover {
					color: #a855f7;
				}

				/* ── PARTICLE DOTS ──────────────────────────────────────── */
				.particles {
					position: absolute;
					inset: 0;
					z-index: 1;
					overflow: hidden;
					pointer-events: none;
				}

				.particle {
					position: absolute;
					width: 2px;
					height: 2px;
					border-radius: 50%;
					background: rgba(255, 255, 255, 0.4);
					animation: float linear infinite;
				}

				@keyframes float {
					0% { transform: translateY(100vh) scale(0); opacity: 0; }
					10% { opacity: 1; }
					90% { opacity: 0.6; }
					100% { transform: translateY(-20px) scale(1); opacity: 0; }
				}

				/* ── RESPONSIVE ─────────────────────────────────────────── */
				@media (max-width: 520px) {
					.glass-card {
						width: 92vw;
						padding: 36px 28px 32px;
					}

					.vinyl-wrap {
						display: none;
					}
				}
			</style>
		</head>

		<body>
			<div class="scene">

				<!-- Ambient orbs -->
				<div class="orb orb-1"></div>
				<div class="orb orb-2"></div>
				<div class="orb orb-3"></div>
				<div class="orb orb-4"></div>

				<!-- Floating particles -->
				<div class="particles" id="particles"></div>

				<!-- Vinyl record (right-side decoration) -->
				<div class="vinyl-wrap">
					<div class="vinyl">
						<svg viewBox="0 0 540 540" xmlns="http://www.w3.org/2000/svg">
							<defs>
								<radialGradient id="vg" cx="50%" cy="50%" r="50%">
									<stop offset="0%" stop-color="#2a1e5a" />
									<stop offset="35%" stop-color="#0f0d1c" />
									<stop offset="36%" stop-color="#1a153a" />
									<stop offset="37%" stop-color="#0f0d1c" />
									<stop offset="50%" stop-color="#130f22" />
									<stop offset="51%" stop-color="#1c1640" />
									<stop offset="52%" stop-color="#130f22" />
									<stop offset="65%" stop-color="#0d0b18" />
									<stop offset="66%" stop-color="#1a153a" />
									<stop offset="67%" stop-color="#0d0b18" />
									<stop offset="85%" stop-color="#0a0812" />
									<stop offset="86%" stop-color="#15112e" />
									<stop offset="87%" stop-color="#0a0812" />
									<stop offset="100%" stop-color="#060408" />
								</radialGradient>
								<radialGradient id="label" cx="50%" cy="50%" r="50%">
									<stop offset="0%" stop-color="#4a3a8a" />
									<stop offset="60%" stop-color="#2d1f6e" />
									<stop offset="100%" stop-color="#1a1040" />
								</radialGradient>
								<radialGradient id="shine" cx="35%" cy="35%" r="60%">
									<stop offset="0%" stop-color="rgba(255,255,255,0.18)" />
									<stop offset="100%" stop-color="rgba(255,255,255,0)" />
								</radialGradient>
								<linearGradient id="groove1" x1="0%" y1="0%" x2="100%" y2="100%">
									<stop offset="0%" stop-color="rgba(123,108,255,0.25)" />
									<stop offset="50%" stop-color="rgba(56,217,245,0.08)" />
									<stop offset="100%" stop-color="rgba(244,63,142,0.18)" />
								</linearGradient>
							</defs>

							<circle cx="270" cy="270" r="268" fill="url(#vg)" />
							<circle cx="270" cy="270" r="268" fill="url(#groove1)" opacity="0.5" />
							<circle cx="270" cy="270" r="268" fill="url(#shine)" opacity="0.6" />

							<circle cx="270" cy="270" r="240" fill="none" stroke="rgba(255,255,255,0.04)" stroke-width="0.8" />
							<circle cx="270" cy="270" r="210" fill="none" stroke="rgba(255,255,255,0.03)" stroke-width="0.6" />
							<circle cx="270" cy="270" r="180" fill="none" stroke="rgba(255,255,255,0.03)" stroke-width="0.6" />
							<circle cx="270" cy="270" r="155" fill="none" stroke="rgba(255,255,255,0.04)" stroke-width="0.8" />
							<circle cx="270" cy="270" r="130" fill="none" stroke="rgba(255,255,255,0.03)" stroke-width="0.5" />
							<circle cx="270" cy="270" r="108" fill="none" stroke="rgba(255,255,255,0.04)" stroke-width="0.6" />

							<circle cx="270" cy="270" r="90" fill="url(#label)" />
							<circle cx="270" cy="270" r="90" fill="url(#shine)" opacity="0.4" />

							<circle cx="270" cy="270" r="10" fill="#0a0812" />
							<circle cx="270" cy="270" r="5" fill="#1a1040" />

							<circle cx="270" cy="270" r="267" fill="none" stroke="rgba(255,255,255,0.12)" stroke-width="1.5" />
						</svg>
					</div>
					<div class="vinyl-light"></div>
				</div>

				<!-- ── REGISTER CARD ────────────────────────────────────── -->
				<div class="glass-card">

					<!-- Brand -->
					<div class="brand">
						<svg class="brand-icon" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
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
						<span class="brand-name">Resonance</span>
					</div>

					<!-- Heading -->
					<h1 class="login-heading">Join the registry.</h1>
					<p class="login-sub">Create an account to get started.</p>

					<!-- Error display -->
					<div class="error-msg" id="errorMsg" role="alert">
						<svg width="15" height="15" viewBox="0 0 15 15" fill="none">
							<circle cx="7.5" cy="7.5" r="6.5" stroke="rgba(244,63,142,0.8)" stroke-width="1.2" />
							<path d="M7.5 4.5v3.5" stroke="rgba(244,63,142,0.9)" stroke-width="1.3" stroke-linecap="round" />
							<circle cx="7.5" cy="10.5" r="0.8" fill="rgba(244,63,142,0.9)" />
						</svg>
						<span id="errorMsgText">Something went wrong.</span>
					</div>

					<!-- Success display -->
					<div class="success-msg" id="successMsg" role="status">
						<svg width="15" height="15" viewBox="0 0 15 15" fill="none">
							<circle cx="7.5" cy="7.5" r="6.5" stroke="rgba(56,217,245,0.8)" stroke-width="1.2" />
							<path d="M4.5 7.5l2 2 4-4" stroke="rgba(56,217,245,0.9)" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
						</svg>
						<span>Account created! Redirecting to sign in...</span>
					</div>

					<!-- Form -->
					<form id="registerForm" novalidate>

						<div class="field">
							<label for="name">Name</label>
							<input type="text" id="name" name="name" placeholder="Your full name" autocomplete="name" required />
						</div>

						<div class="field">
							<label for="username">Username</label>
							<input type="text" id="username" name="username" placeholder="Choose a username" autocomplete="username" required />
						</div>

						<div class="field">
							<label for="password">Password</label>
							<input type="password" id="password" name="password" placeholder="••••••••" autocomplete="new-password" required minlength="6" />
						</div>

						<div class="field">
							<label for="confirmPassword">Confirm Password</label>
							<input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••••" autocomplete="new-password" required minlength="6" />
							<p class="hint" id="matchHint"></p>
						</div>

						<button type="submit" class="btn-signin" id="submitBtn">Create Account</button>

					</form>

					<p class="footer-text">
						Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
					</p>

				</div><!-- /glass-card -->

			</div><!-- /scene -->

			<script>
				/* ── Floating particles ──────────────────────────────────── */
				(function () {
					const container = document.getElementById('particles');
					const count = 28;
					for (let i = 0; i < count; i++) {
						const p = document.createElement('div');
						p.className = 'particle';
						p.style.left = Math.random() * 100 + 'vw';
						p.style.width = (Math.random() * 2 + 1) + 'px';
						p.style.height = p.style.width;
						p.style.animationDuration = (Math.random() * 18 + 10) + 's';
						p.style.animationDelay = (Math.random() * -20) + 's';
						p.style.opacity = (Math.random() * 0.5 + 0.2).toString();
						const tints = ['rgba(123,108,255,0.7)', 'rgba(244,63,142,0.6)', 'rgba(56,217,245,0.5)', 'rgba(255,255,255,0.5)'];
						p.style.background = tints[Math.floor(Math.random() * tints.length)];
						container.appendChild(p);
					}
				})();

				/* ── Subtle card mouse-tilt (liquid feel) ────────────────── */
				(function () {
					const card = document.querySelector('.glass-card');
					card.addEventListener('mousemove', function (e) {
						const rect = card.getBoundingClientRect();
						const cx = rect.left + rect.width / 2;
						const cy = rect.top + rect.height / 2;
						const dx = (e.clientX - cx) / (rect.width / 2);
						const dy = (e.clientY - cy) / (rect.height / 2);
						card.style.transform = `perspective(800px) rotateY(${dx * 4}deg) rotateX(${-dy * 3}deg)`;
					});
					card.addEventListener('mouseleave', function () {
						card.style.transform = 'perspective(800px) rotateY(0deg) rotateX(0deg)';
					});
				})();

				/* ── Registration form logic ─────────────────────────────── */
				(function () {
					const form = document.getElementById('registerForm');
					const nameInput = document.getElementById('name');
					const usernameInput = document.getElementById('username');
					const passwordInput = document.getElementById('password');
					const confirmInput = document.getElementById('confirmPassword');
					const matchHint = document.getElementById('matchHint');
					const errorMsg = document.getElementById('errorMsg');
					const errorMsgText = document.getElementById('errorMsgText');
					const successMsg = document.getElementById('successMsg');
					const submitBtn = document.getElementById('submitBtn');

					const contextPath = '${pageContext.request.contextPath}';

					function checkPasswordsMatch() {
						if (!confirmInput.value) {
							matchHint.textContent = '';
							matchHint.classList.remove('mismatch');
							confirmInput.classList.remove('field-invalid');
							return true;
						}
						const matches = passwordInput.value === confirmInput.value;
						matchHint.textContent = matches ? 'Passwords match.' : 'Passwords do not match.';
						matchHint.classList.toggle('mismatch', !matches);
						confirmInput.classList.toggle('field-invalid', !matches);
						return matches;
					}

					passwordInput.addEventListener('input', checkPasswordsMatch);
					confirmInput.addEventListener('input', checkPasswordsMatch);

					function showError(message) {
						errorMsgText.textContent = message;
						errorMsg.classList.add('show');
						successMsg.classList.remove('show');
					}

					function hideError() {
						errorMsg.classList.remove('show');
					}

					form.addEventListener('submit', async function (e) {
						e.preventDefault();
						hideError();

						const name = nameInput.value.trim();
						const username = usernameInput.value.trim();
						const password = passwordInput.value;
						const confirmPassword = confirmInput.value;

						if (!name || !username || !password || !confirmPassword) {
							showError('Please fill in all fields.');
							return;
						}

						if (password.length < 6) {
							showError('Password must be at least 6 characters long.');
							return;
						}

						if (!checkPasswordsMatch()) {
							showError('Passwords do not match.');
							return;
						}

						submitBtn.disabled = true;
						submitBtn.textContent = 'Creating Account...';

						try {
							const response = await fetch(contextPath + 'api/artists/user', {
								method: 'POST',
								headers: {
									'Content-Type': 'application/json'
								},
								body: JSON.stringify({ name: name, username: username, password: password })
							});

							if (response.ok) {
								successMsg.classList.add('show');
								form.reset();
								setTimeout(function () {
									window.location.href = contextPath + '/login';
								}, 1400);
							} else {
								const text = await response.text();
								showError(text || 'Registration failed. Please try again.');
								submitBtn.disabled = false;
								submitBtn.textContent = 'Create Account';
							}
						} catch (err) {
							showError('Network error. Please try again.');
							submitBtn.disabled = false;
							submitBtn.textContent = 'Create Account';
						}
					});
				})();
			</script>
		</body>

		</html>
