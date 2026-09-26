<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><c:if test="${not empty artist.name}"><c:out value="${artist.name}"/> — </c:if>Add Song — Resonance</title>
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
	<link
		href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=Syne:wght@400;500;600;700&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;1,9..40,300&display=swap"
		rel="stylesheet" />
	<style>
		*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

		:root {
			--red: #e8302a;
			--red-light: #ff6b5b;
			--red-deep: #9b1a15;
			--blue: #2563eb;
			--blue-light: #60a5fa;
			--grad: linear-gradient(135deg, var(--red) 0%, #8b2be2 50%, var(--blue) 100%);
			--glass-bg: rgba(255, 255, 255, 0.038);
			--glass-border: rgba(255, 255, 255, 0.09);
			--text-primary: #f0eefa;
			--text-secondary: rgba(240, 238, 250, 0.52);
			--text-muted: rgba(240, 238, 250, 0.28);
			--nav-h: 66px;
			--ok: #34d399;
			--err: #ff6b5b;
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

		@keyframes drift {
			0% { transform: translate(0, 0) scale(1); }
			33% { transform: translate(45px, -38px) scale(1.06); }
			66% { transform: translate(-32px, 52px) scale(0.96); }
			100% { transform: translate(22px, -22px) scale(1.03); }
		}

		.wrapper { position: relative; z-index: 1; max-width: 760px; margin: 0 auto; padding: 0 2rem; }

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

		.nav-inner { display: flex; align-items: center; justify-content: space-between; width: 100%; }
		.logo { text-decoration: none; display: flex; align-items: center; gap: 10px; }
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

		.btn-back {
			display: inline-flex;
			align-items: center;
			gap: 6px;
			color: var(--text-secondary);
			text-decoration: none;
			font-size: 0.85rem;
			font-weight: 600;
			padding: 0.5rem 0.9rem;
			border: 1px solid var(--glass-border);
			border-radius: 8px;
			transition: all 0.2s;
		}
		.btn-back:hover { color: var(--text-primary); border-color: rgba(255,255,255,0.25); background: rgba(255,255,255,0.05); }

		main { position: relative; z-index: 1; padding: 2.5rem 0 5rem; }

		.breadcrumb { display: flex; align-items: center; gap: 0.4rem; font-size: 0.82rem; color: var(--text-muted); margin-bottom: 1.5rem; flex-wrap: wrap; }
		.breadcrumb a { color: var(--text-secondary); text-decoration: none; }
		.breadcrumb a:hover { color: var(--text-primary); }
		.breadcrumb svg { width: 12px; height: 12px; }

		.page-head { margin-bottom: 2rem; }
		.page-head h1 {
			font-family: 'Syne', sans-serif;
			font-size: 1.9rem;
			font-weight: 700;
			letter-spacing: -0.01em;
			margin-bottom: 0.4rem;
		}
		.page-head p { color: var(--text-secondary); font-size: 0.92rem; }
		.page-head strong { color: var(--text-primary); }

		.card {
			background: var(--glass-bg);
			border: 1px solid var(--glass-border);
			border-radius: 18px;
			padding: 2rem;
			backdrop-filter: blur(20px);
		}

		.field { margin-bottom: 1.4rem; }
		.field label {
			display: block;
			font-size: 0.78rem;
			font-weight: 700;
			letter-spacing: 0.04em;
			text-transform: uppercase;
			color: var(--text-secondary);
			margin-bottom: 0.5rem;
		}
		.field .hint { font-size: 0.78rem; color: var(--text-muted); margin-top: 0.4rem; }

		.field input[type="text"],
		.field input[type="number"] {
			width: 100%;
			padding: 0.75rem 0.9rem;
			background: rgba(255,255,255,0.03);
			border: 1px solid var(--glass-border);
			border-radius: 10px;
			color: var(--text-primary);
			font-family: 'DM Sans', sans-serif;
			font-size: 0.92rem;
			transition: border-color 0.2s, background 0.2s;
		}
		.field input[type="text"]:focus,
		.field input[type="number"]:focus {
			outline: none;
			border-color: rgba(139, 92, 246, 0.55);
			background: rgba(255,255,255,0.05);
		}

		.row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; }
		@media (max-width: 560px) { .row-2 { grid-template-columns: 1fr; } }

		/* File drop zone */
		.dropzone {
			border: 1.5px dashed var(--glass-border);
			border-radius: 12px;
			padding: 1.6rem;
			text-align: center;
			cursor: pointer;
			transition: border-color 0.2s, background 0.2s;
			position: relative;
		}
		.dropzone:hover, .dropzone.drag-over {
			border-color: rgba(139, 92, 246, 0.55);
			background: rgba(139, 92, 246, 0.05);
		}
		.dropzone input[type="file"] { position: absolute; inset: 0; opacity: 0; cursor: pointer; }
		.dropzone-icon { margin: 0 auto 0.6rem; width: 34px; height: 34px; color: var(--text-muted); }
		.dropzone-text { font-size: 0.88rem; color: var(--text-secondary); }
		.dropzone-text strong { color: #c4b5fd; }
		.dropzone-file { font-size: 0.82rem; color: var(--text-primary); margin-top: 0.5rem; font-weight: 600; }

		/* Progress */
		.progress-wrap { margin-top: 0.9rem; display: none; }
		.progress-wrap.active { display: block; }
		.progress-track { height: 6px; border-radius: 999px; background: rgba(255,255,255,0.08); overflow: hidden; }
		.progress-fill { height: 100%; width: 0%; background: var(--grad); transition: width 0.2s ease; }
		.progress-label { font-size: 0.76rem; color: var(--text-muted); margin-top: 0.4rem; }

		/* Status banner */
		.status-banner {
			display: none;
			align-items: center;
			gap: 8px;
			padding: 0.75rem 1rem;
			border-radius: 10px;
			font-size: 0.85rem;
			font-weight: 600;
			margin-bottom: 1.4rem;
		}
		.status-banner.show { display: flex; }
		.status-banner.error { background: rgba(232, 48, 42, 0.12); border: 1px solid rgba(232, 48, 42, 0.35); color: var(--red-light); }
		.status-banner.success { background: rgba(52, 211, 153, 0.12); border: 1px solid rgba(52, 211, 153, 0.35); color: var(--ok); }

		.field-error { font-size: 0.76rem; color: var(--red-light); margin-top: 0.4rem; display: none; }
		.field-error.show { display: block; }
		.field.invalid input { border-color: rgba(232, 48, 42, 0.6); }

		.actions { display: flex; gap: 0.8rem; margin-top: 1.8rem; }

		.btn-submit {
			flex: 1;
			display: inline-flex;
			align-items: center;
			justify-content: center;
			gap: 8px;
			padding: 0.85rem 1.4rem;
			background: var(--grad);
			border: none;
			border-radius: 12px;
			color: #fff;
			font-family: 'Syne', sans-serif;
			font-size: 0.92rem;
			font-weight: 700;
			letter-spacing: 0.02em;
			cursor: pointer;
			transition: opacity 0.2s, transform 0.15s;
		}
		.btn-submit:hover:not(:disabled) { transform: translateY(-1px); }
		.btn-submit:disabled { opacity: 0.55; cursor: not-allowed; }

		.btn-cancel {
			padding: 0.85rem 1.3rem;
			background: transparent;
			border: 1px solid var(--glass-border);
			border-radius: 12px;
			color: var(--text-secondary);
			font-family: 'DM Sans', sans-serif;
			font-size: 0.88rem;
			font-weight: 600;
			cursor: pointer;
			text-decoration: none;
			display: inline-flex;
			align-items: center;
			transition: all 0.2s;
		}
		.btn-cancel:hover { color: var(--text-primary); border-color: rgba(255,255,255,0.25); }

		.spinner {
			width: 15px; height: 15px;
			border: 2px solid rgba(255,255,255,0.35);
			border-top-color: #fff;
			border-radius: 50%;
			animation: spin 0.7s linear infinite;
			display: none;
		}
		.spinner.show { display: inline-block; }
		@keyframes spin { to { transform: rotate(360deg); } }

		.artist-chip {
			display: inline-flex;
			align-items: center;
			gap: 8px;
			padding: 0.4rem 0.8rem 0.4rem 0.4rem;
			background: rgba(255,255,255,0.04);
			border: 1px solid var(--glass-border);
			border-radius: 999px;
			font-size: 0.82rem;
			margin-top: 0.6rem;
		}
		.artist-chip img {
			width: 26px; height: 26px; border-radius: 50%; object-fit: cover;
		}
		.artist-chip-fallback {
			width: 26px; height: 26px; border-radius: 50%;
			background: var(--grad);
			display: flex; align-items: center; justify-content: center;
			font-family: 'Syne', sans-serif; font-weight: 700; font-size: 0.7rem;
		}

		/* Auto-detected duration */
		.duration-display {
			display: flex;
			align-items: center;
			justify-content: space-between;
			gap: 0.6rem;
			padding: 0.75rem 0.9rem;
			background: rgba(255,255,255,0.03);
			border: 1px solid var(--glass-border);
			border-radius: 10px;
			font-size: 0.92rem;
		}
		.duration-display.detected { color: var(--ok); border-color: rgba(52, 211, 153, 0.35); }
		.duration-display .link-btn {
			background: none;
			border: none;
			color: #c4b5fd;
			font-size: 0.78rem;
			font-weight: 600;
			cursor: pointer;
			padding: 0;
			text-decoration: underline;
			text-underline-offset: 2px;
			flex-shrink: 0;
		}

		/* Collaborator chip input */
		.chip-input {
			display: flex;
			flex-wrap: wrap;
			align-items: center;
			gap: 0.5rem;
			padding: 0.6rem 0.7rem;
			background: rgba(255,255,255,0.03);
			border: 1px solid var(--glass-border);
			border-radius: 10px;
		}
		.chip-input:focus-within { border-color: rgba(139, 92, 246, 0.55); background: rgba(255,255,255,0.05); }
		.chip-input input {
			flex: 1;
			min-width: 140px;
			border: none;
			background: none;
			outline: none;
			color: var(--text-primary);
			font-family: 'DM Sans', sans-serif;
			font-size: 0.9rem;
			padding: 0.3rem 0;
		}
		.collab-chip {
			display: inline-flex;
			align-items: center;
			gap: 6px;
			padding: 0.3rem 0.4rem 0.3rem 0.7rem;
			background: rgba(139, 92, 246, 0.14);
			border: 1px solid rgba(139, 92, 246, 0.35);
			border-radius: 999px;
			font-size: 0.8rem;
			color: #e4defc;
			white-space: nowrap;
		}
		.collab-chip button {
			width: 16px; height: 16px;
			display: flex; align-items: center; justify-content: center;
			border: none; border-radius: 50%;
			background: rgba(255,255,255,0.12);
			color: var(--text-primary);
			cursor: pointer;
			font-size: 0.75rem;
			line-height: 1;
			padding: 0;
		}
		.collab-chip button:hover { background: rgba(232, 48, 42, 0.5); }

		.collab-suggest-wrap { position: relative; }
		.collab-suggest-list {
			position: absolute;
			top: calc(100% + 6px);
			left: 0;
			right: 0;
			background: rgba(14, 9, 20, 0.97);
			border: 1px solid var(--glass-border);
			border-radius: 10px;
			max-height: 240px;
			overflow-y: auto;
			z-index: 30;
			display: none;
			box-shadow: 0 12px 30px rgba(0,0,0,0.4);
		}
		.collab-suggest-list.show { display: block; }
		.collab-suggest-item {
			display: flex;
			align-items: center;
			gap: 10px;
			padding: 0.55rem 0.75rem;
			cursor: pointer;
			font-size: 0.85rem;
		}
		.collab-suggest-item:hover, .collab-suggest-item.active { background: rgba(139, 92, 246, 0.14); }
		.collab-suggest-item img, .collab-suggest-item .fallback-thumb {
			width: 24px; height: 24px; border-radius: 50%; object-fit: cover; flex-shrink: 0;
		}
		.collab-suggest-item .fallback-thumb {
			background: var(--grad);
			display: flex; align-items: center; justify-content: center;
			font-family: 'Syne', sans-serif; font-weight: 700; font-size: 0.68rem;
		}
		.collab-suggest-item .name { color: var(--text-primary); }
		.collab-suggest-empty {
			padding: 0.6rem 0.75rem;
			color: var(--text-muted);
			font-size: 0.8rem;
		}
	</style>
</head>

<body>

	<div class="bg-canvas">
		<div class="orb orb-1"></div>
		<div class="orb orb-2"></div>
		<div class="orb orb-3"></div>
	</div>

	<nav>
		<div class="wrapper nav-inner">
			<a class="logo" href="${pageContext.request.contextPath}/">
				<span class="logo-name">Resonance</span>
			</a>
			<a class="btn-back" href="${pageContext.request.contextPath}/artist-details/${artistId}">
				<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
					<line x1="19" y1="12" x2="5" y2="12" />
					<polyline points="12 19 5 12 12 5" />
				</svg>
				Back to Artist
			</a>
		</div>
	</nav>

	<main>
		<div class="wrapper">

			<nav class="breadcrumb" aria-label="Breadcrumb">
				<a href="${pageContext.request.contextPath}/">Home</a>
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="9 18 15 12 9 6" /></svg>
				<a href="${pageContext.request.contextPath}/artist-details/${artistId}"><c:out value="${not empty artist.name ? artist.name : 'Artist'}"/></a>
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="9 18 15 12 9 6" /></svg>
				<span>Add Song</span>
			</nav>

			<div class="page-head">
				<h1>Add a Song</h1>
				<p>
					Adding a new track for
					<c:choose>
						<c:when test="${not empty artist.name}"><strong><c:out value="${artist.name}"/></strong></c:when>
						<c:otherwise>artist <strong><c:out value="${artistId}"/></strong></c:otherwise>
					</c:choose>
				</p>
				<div class="artist-chip">
					<c:choose>
						<c:when test="${not empty artist.imageURL}">
							<img src="<c:out value='${artist.imageURL}'/>" alt="" onerror="this.replaceWith(Object.assign(document.createElement('div'),{className:'artist-chip-fallback',textContent:'?'}))" />
						</c:when>
						<c:otherwise>
							<div class="artist-chip-fallback"><c:if test="${not empty artist.name}"><c:out value="${artist.name.substring(0,1)}"/></c:if><c:if test="${empty artist.name}">?</c:if></div>
						</c:otherwise>
					</c:choose>
					<code style="font-size:0.76rem;letter-spacing:0;color:var(--text-secondary)"><c:out value="${artistId}"/></code>
				</div>
			</div>

			<div id="status-banner" class="status-banner"></div>

			<div class="card">
				<form id="add-song-form" novalidate>

					<div class="field" id="field-songName">
						<label for="songName">Song Name</label>
						<input type="text" id="songName" name="songName" placeholder="e.g. Blinding Lights" autocomplete="off" />
						<div class="field-error">Song name is required.</div>
					</div>

					<div class="row-2">
						<div class="field" id="field-albumName">
							<label for="albumName">Album Name</label>
							<input type="text" id="albumName" name="albumName" placeholder="e.g. After Hours" autocomplete="off" />
						</div>
						<div class="field" id="field-duration">
							<label for="duration">Duration</label>
							<div class="duration-display" id="duration-display">
								<span id="duration-value">Select a file below to detect it</span>
								<button type="button" class="link-btn" id="duration-manual-toggle">Enter manually</button>
							</div>
							<input type="number" id="duration" name="duration" placeholder="e.g. 200" min="1" style="display:none;" />
							<div class="field-error">Enter a valid duration in seconds, or choose a file so it can be detected automatically.</div>
						</div>
					</div>

					<div class="field" id="field-collaborators">
						<label for="collaboratorInput">Collaborators <span style="text-transform:none;font-weight:500;color:var(--text-muted);">(optional)</span></label>
						<div class="collab-suggest-wrap">
							<div class="chip-input" id="chip-input">
								<input type="text" id="collaboratorInput" placeholder="Search artists by name…" autocomplete="off" />
							</div>
							<div class="collab-suggest-list" id="collab-suggest-list"></div>
						</div>
						<div class="hint">Add other artists this song should also appear under.</div>
					</div>

					<div class="field" id="field-file">
						<label>Song File</label>
						<div class="dropzone" id="dropzone">
							<input type="file" id="songFile" name="songFile" accept="audio/*" />
							<svg class="dropzone-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
								<path d="M9 18V5l12-2v13" /><circle cx="6" cy="18" r="3" /><circle cx="18" cy="16" r="3" />
							</svg>
							<div class="dropzone-text"><strong>Click to upload</strong> or drag and drop an MP3 file</div>
							<div class="dropzone-file" id="dropzone-file"></div>
						</div>
						<div class="field-error">Please choose an audio file to upload.</div>

						<div class="progress-wrap" id="progress-wrap">
							<div class="progress-track"><div class="progress-fill" id="progress-fill"></div></div>
							<div class="progress-label" id="progress-label">Preparing upload…</div>
						</div>
					</div>

					<div class="actions">
						<a class="btn-cancel" href="${pageContext.request.contextPath}/artist-details/${artistId}">Cancel</a>
						<button type="submit" class="btn-submit" id="submit-btn">
							<span class="spinner" id="submit-spinner"></span>
							<span id="submit-label">Add Song</span>
						</button>
					</div>

				</form>
			</div>

		</div>
	</main>

	<script>
		const CTX = '${pageContext.request.contextPath}';
		const ARTIST_ID = '<c:out value="${artistId}"/>';

		const form = document.getElementById('add-song-form');
		const dropzone = document.getElementById('dropzone');
		const fileInput = document.getElementById('songFile');
		const dropzoneFileLabel = document.getElementById('dropzone-file');
		const submitBtn = document.getElementById('submit-btn');
		const submitSpinner = document.getElementById('submit-spinner');
		const submitLabel = document.getElementById('submit-label');
		const progressWrap = document.getElementById('progress-wrap');
		const progressFill = document.getElementById('progress-fill');
		const progressLabel = document.getElementById('progress-label');
		const statusBanner = document.getElementById('status-banner');

		const durationInput = document.getElementById('duration');
		const durationDisplay = document.getElementById('duration-display');
		const durationValueEl = document.getElementById('duration-value');
		const durationManualToggle = document.getElementById('duration-manual-toggle');

		const chipInputWrap = document.getElementById('chip-input');
		const collaboratorInput = document.getElementById('collaboratorInput');
		const suggestList = document.getElementById('collab-suggest-list');
		const collaboratorIds = [];

		/* ── Drag & drop niceties ── */
		['dragenter', 'dragover'].forEach(evt =>
			dropzone.addEventListener(evt, e => { e.preventDefault(); dropzone.classList.add('drag-over'); })
		);
		['dragleave', 'drop'].forEach(evt =>
			dropzone.addEventListener(evt, e => { e.preventDefault(); dropzone.classList.remove('drag-over'); })
		);
		dropzone.addEventListener('drop', e => {
			if (e.dataTransfer.files.length) {
				fileInput.files = e.dataTransfer.files;
				updateFileLabel();
			}
		});
		fileInput.addEventListener('change', updateFileLabel);

		function updateFileLabel() {
			const file = fileInput.files[0];
			dropzoneFileLabel.textContent = file ? (file.name + ' — ' + formatBytes(file.size)) : '';
			clearFieldError('file');
			if (file) detectDuration(file);
		}

		function formatBytes(bytes) {
			if (!bytes) return '0 B';
			const units = ['B', 'KB', 'MB', 'GB'];
			const i = Math.floor(Math.log(bytes) / Math.log(1024));
			return (bytes / Math.pow(1024, i)).toFixed(1) + ' ' + units[i];
		}

		/* ── Auto-detect duration from the audio file itself (no server round-trip
		   needed — the browser can read media metadata off a local file). ── */
		function formatDuration(totalSeconds) {
			const minutes = Math.floor(totalSeconds / 60);
			const seconds = Math.floor(totalSeconds % 60);
			return minutes + ':' + String(seconds).padStart(2, '0');
		}

		function detectDuration(file) {
			durationValueEl.textContent = 'Detecting duration…';
			durationDisplay.classList.remove('detected');

			const objectUrl = URL.createObjectURL(file);
			const probe = new Audio();

			const cleanup = () => URL.revokeObjectURL(objectUrl);

			probe.addEventListener('loadedmetadata', () => {
				const seconds = Math.round(probe.duration);
				cleanup();
				if (!isFinite(seconds) || seconds <= 0) {
					fallbackToManualDuration();
					return;
				}
				durationInput.value = seconds;
				durationValueEl.textContent = formatDuration(seconds) + ' (auto-detected)';
				durationDisplay.classList.add('detected');
				clearFieldError('duration');
			});

			probe.addEventListener('error', () => {
				cleanup();
				fallbackToManualDuration();
			});

			probe.src = objectUrl;
		}

		function fallbackToManualDuration() {
			durationValueEl.textContent = "Couldn't detect duration automatically";
			durationDisplay.classList.remove('detected');
			showManualDurationInput();
		}

		function showManualDurationInput() {
			durationDisplay.style.display = 'none';
			durationInput.style.display = 'block';
			durationInput.focus();
		}

		durationManualToggle.addEventListener('click', showManualDurationInput);

		/* ── Collaborators (multi-artist) chip input, backed by the artist search endpoint ── */
		function addCollaboratorChip(id, label) {
			const trimmedId = String(id).trim();
			if (!trimmedId || trimmedId === ARTIST_ID || collaboratorIds.includes(trimmedId)) return;

			collaboratorIds.push(trimmedId);

			const chip = document.createElement('span');
			chip.className = 'collab-chip';
			chip.dataset.id = trimmedId;

			const chipLabel = document.createElement('span');
			chipLabel.textContent = label || trimmedId;

			const removeBtn = document.createElement('button');
			removeBtn.type = 'button';
			removeBtn.setAttribute('aria-label', 'Remove collaborator');
			removeBtn.textContent = '\u00d7';
			removeBtn.addEventListener('click', () => {
				const idx = collaboratorIds.indexOf(trimmedId);
				if (idx > -1) collaboratorIds.splice(idx, 1);
				chip.remove();
			});

			chip.appendChild(chipLabel);
			chip.appendChild(removeBtn);
			chipInputWrap.insertBefore(chip, collaboratorInput);
		}

		/* Search-as-you-type against the artist search endpoint (JSON sibling of
		   GET /api/artists/search, which itself renders the "search" view). */
		let searchDebounceTimer = null;
		let currentSuggestions = [];
		let activeSuggestIndex = -1;

		function artistThumb(artist) {
			if (artist.imageURL) {
				const img = document.createElement('img');
				img.src = artist.imageURL;
				img.alt = '';
				img.onerror = () => img.replaceWith(fallbackThumb(artist));
				return img;
			}
			return fallbackThumb(artist);
		}
		function fallbackThumb(artist) {
			const div = document.createElement('div');
			div.className = 'fallback-thumb';
			div.textContent = (artist.name || '?').charAt(0).toUpperCase();
			return div;
		}

		function renderSuggestions(artists) {
			currentSuggestions = artists;
			activeSuggestIndex = -1;
			suggestList.innerHTML = '';

			if (!artists.length) {
				const empty = document.createElement('div');
				empty.className = 'collab-suggest-empty';
				empty.textContent = 'No matching artists.';
				suggestList.appendChild(empty);
				suggestList.classList.add('show');
				return;
			}

			artists.forEach((artist, i) => {
				const item = document.createElement('div');
				item.className = 'collab-suggest-item';
				item.appendChild(artistThumb(artist));
				const name = document.createElement('span');
				name.className = 'name';
				name.textContent = artist.name || artist.mongoId;
				item.appendChild(name);
				item.addEventListener('mousedown', (e) => {
					// mousedown (not click) so this fires before the input's blur handler
					e.preventDefault();
					selectSuggestion(i);
				});
				suggestList.appendChild(item);
			});
			suggestList.classList.add('show');
		}

		function selectSuggestion(index) {
			const artist = currentSuggestions[index];
			if (!artist) return;
			addCollaboratorChip(artist.mongoId, artist.name);
			collaboratorInput.value = '';
			closeSuggestions();
		}

		function closeSuggestions() {
			suggestList.classList.remove('show');
			suggestList.innerHTML = '';
			currentSuggestions = [];
			activeSuggestIndex = -1;
		}

		function searchArtists(query) {
			fetch(CTX + '/api/artists/search?name=' + encodeURIComponent(query))
				.then(res => {
					if (!res.ok) throw new Error('Search failed with status ' + res.status);
					return res.json();
				})
				.then(data => {
					// ArtistSlice shape: { content: Artist[], hasPrevious, hasNext }
					const artists = data.content || [];
					renderSuggestions(artists.filter(a => a.mongoId !== ARTIST_ID && !collaboratorIds.includes(a.mongoId)));
				})
				.catch(err => {
					console.error('Artist search failed: ', err);
					closeSuggestions();
				});
		}

		collaboratorInput.addEventListener('input', () => {
			const query = collaboratorInput.value.trim();
			clearTimeout(searchDebounceTimer);
			if (query.length < 2) { closeSuggestions(); return; }
			searchDebounceTimer = setTimeout(() => searchArtists(query), 300);
		});

		collaboratorInput.addEventListener('keydown', (e) => {
			if (suggestList.classList.contains('show') && currentSuggestions.length) {
				if (e.key === 'ArrowDown') {
					e.preventDefault();
					activeSuggestIndex = Math.min(activeSuggestIndex + 1, currentSuggestions.length - 1);
					updateActiveSuggestion();
					return;
				}
				if (e.key === 'ArrowUp') {
					e.preventDefault();
					activeSuggestIndex = Math.max(activeSuggestIndex - 1, 0);
					updateActiveSuggestion();
					return;
				}
				if (e.key === 'Enter' && activeSuggestIndex > -1) {
					e.preventDefault();
					selectSuggestion(activeSuggestIndex);
					return;
				}
			}
			if (e.key === 'Enter') {
				// No suggestion highlighted — fall back to treating the typed text
				// as a literal artist ID, so pasting a known mongoId still works.
				e.preventDefault();
				if (collaboratorInput.value.trim()) {
					addCollaboratorChip(collaboratorInput.value, collaboratorInput.value.trim());
					collaboratorInput.value = '';
					closeSuggestions();
				}
			} else if (e.key === 'Escape') {
				closeSuggestions();
			} else if (e.key === 'Backspace' && !collaboratorInput.value && collaboratorIds.length) {
				const lastChip = chipInputWrap.querySelector('.collab-chip:last-of-type');
				if (lastChip) lastChip.querySelector('button').click();
			}
		});

		function updateActiveSuggestion() {
			[...suggestList.children].forEach((el, i) => el.classList.toggle('active', i === activeSuggestIndex));
		}

		document.addEventListener('click', (e) => {
			if (!chipInputWrap.contains(e.target) && !suggestList.contains(e.target)) closeSuggestions();
		});

		/* ── Validation ── */
		function setFieldError(key, show) {
			const field = document.getElementById('field-' + key);
			if (!field) return;
			field.classList.toggle('invalid', show);
			const err = field.querySelector('.field-error');
			if (err) err.classList.toggle('show', show);
		}
		function clearFieldError(key) { setFieldError(key, false); }

		function validateForm() {
			let valid = true;
			const songName = document.getElementById('songName').value.trim();
			const duration = document.getElementById('duration').value;
			const file = fileInput.files[0];

			if (!songName) { setFieldError('songName', true); valid = false; } else { clearFieldError('songName'); }
			if (!duration || Number(duration) <= 0) { setFieldError('duration', true); valid = false; } else { clearFieldError('duration'); }
			if (!file) { setFieldError('file', true); valid = false; } else { clearFieldError('file'); }

			return valid;
		}

		/* ── Status banner ── */
		function showStatus(message, type) {
			statusBanner.textContent = message;
			statusBanner.className = 'status-banner show ' + type;
		}
		function hideStatus() {
			statusBanner.className = 'status-banner';
		}

		/* ── Busy state ── */
		function setBusy(isBusy, label) {
			submitBtn.disabled = isBusy;
			submitSpinner.classList.toggle('show', isBusy);
			submitLabel.textContent = label || 'Add Song';
		}

		function setProgress(pct, label) {
			progressWrap.classList.add('active');
			progressFill.style.width = pct + '%';
			progressLabel.textContent = label;
		}

		/* ── PUT to S3 with progress via XHR (fetch can't report upload progress) ── */
		function uploadToS3(uploadUrl, file) {
			return new Promise((resolve, reject) => {
				const xhr = new XMLHttpRequest();
				xhr.open('PUT', uploadUrl, true);
				xhr.setRequestHeader('Content-Type', file.type || 'application/octet-stream');

				xhr.upload.onprogress = (e) => {
					if (e.lengthComputable) {
						const pct = Math.round((e.loaded / e.total) * 100);
						setProgress(pct, 'Uploading to storage… ' + pct + '%');
					}
				};
				xhr.onload = () => {
					if (xhr.status >= 200 && xhr.status < 300) resolve();
					else reject(new Error('S3 upload failed with status ' + xhr.status));
				};
				xhr.onerror = () => reject(new Error('Network error while uploading to storage.'));
				xhr.send(file);
			});
		}

		form.addEventListener('submit', async (e) => {
			e.preventDefault();
			hideStatus();

			if (!validateForm()) return;
			if (!ARTIST_ID) {
				showStatus('Missing artist context — please go back and try again.', 'error');
				return;
			}

			const songName = document.getElementById('songName').value.trim();
			const albumName = document.getElementById('albumName').value.trim();
			const duration = Number(document.getElementById('duration').value);
			const file = fileInput.files[0];

			try {
				/* Step 1 — request the presigned URL */
				setBusy(true, 'Requesting upload URL…');
				setProgress(5, 'Requesting a secure upload link…');

				const presignRes = await fetch('http://localhost:8080/api/songs/presigned-url', {
					method: 'POST',
					headers: { 'Content-Type': 'application/json' },
					body: JSON.stringify({ fileName: file.name, contentType: file.type || 'audio/mpeg' })
				});
				if (!presignRes.ok) throw new Error('Could not get an upload URL (status ' + presignRes.status + ').');
				const data = await presignRes.json();
				console.log('Presigned URL response data ', data);
				
				const uploadURL = data.uploadURL;
				const storageURL = data.storageURL;
				
				if (!uploadURL || !storageURL) throw new Error('Server response was missing the upload URL.');

				/* Step 2 — PUT the raw file to S3 */
				setBusy(true, 'Uploading file…');
				setProgress(10, 'Uploading to storage…');
				await uploadToS3(uploadURL, file);

				/* Step 3 — commit song metadata */
				setBusy(true, 'Saving song…');
				setProgress(100, 'Saving song details…');

				const songPayload = {
					songName: songName,
					albumName: albumName || null,
					duration: duration,
					s3URL: storageURL,
					artistIds: [ARTIST_ID, ...collaboratorIds]
				};

				const songRes = await fetch('http://localhost:8080/api/songs', {
					method: 'POST',
					headers: { 'Content-Type': 'application/json' },
					body: JSON.stringify(songPayload)
				});
				if (songRes.status !== 201 && songRes.status !== 200) {
					let msg = 'Could not save the song (status ' + songRes.status + ').';
					try {
						const errBody = await songRes.json();
						if (errBody && errBody.message) msg = errBody.message;
					} catch (_) {}
					throw new Error(msg);
				}

				showStatus('Song added successfully. Redirecting…', 'success');
				setTimeout(() => {
					window.location.href = CTX + '/artist-details/' + ARTIST_ID;
				}, 1100);

			} catch (err) {
				console.error(err);
				showStatus(err.message || 'Something went wrong while adding the song.', 'error');
				setBusy(false, 'Add Song');
				progressWrap.classList.remove('active');
				progressFill.style.width = '0%';
			}
		});
	</script>

</body>
</html>
