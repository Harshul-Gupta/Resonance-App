<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>Manage <c:out value="${not empty artist.name ? artist.name : 'Artist'}"/> — Resonance</title>
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
	<link
		href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;1,9..40,300&display=swap"
		rel="stylesheet" />
	<style>
		*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

		:root {
			--red: #e8302a;
			--blue: #2563eb;
			--grad: linear-gradient(135deg, var(--red) 0%, #8b2be2 50%, var(--blue) 100%);
			--glass-bg: rgba(255, 255, 255, 0.038);
			--glass-border: rgba(255, 255, 255, 0.09);
			--text-primary: #f0eefa;
			--text-secondary: rgba(240, 238, 250, 0.52);
			--text-muted: rgba(240, 238, 250, 0.28);
		}

		body {
			min-height: 100vh;
			background: #07050f;
			background-image:
				radial-gradient(ellipse 80% 60% at 15% 10%, rgba(120, 10, 8, 0.45) 0%, transparent 60%),
				radial-gradient(ellipse 70% 55% at 88% 85%, rgba(20, 40, 160, 0.35) 0%, transparent 60%);
			color: var(--text-primary);
			font-family: 'DM Sans', sans-serif;
			font-size: 15px;
			line-height: 1.6;
			padding: 2.5rem 1.5rem 4rem;
		}

		.wrapper { max-width: 760px; margin: 0 auto; }

		.back-link {
			display: inline-flex;
			align-items: center;
			gap: 0.4rem;
			color: var(--text-secondary);
			text-decoration: none;
			font-size: 0.88rem;
			margin-bottom: 1.5rem;
			transition: color 0.15s;
		}
		.back-link:hover { color: var(--text-primary); }

		.page-title {
			font-family: 'Syne', sans-serif;
			font-weight: 700;
			font-size: clamp(1.6rem, 4vw, 2.2rem);
			margin-bottom: 0.25rem;
		}

		.page-subtitle {
			color: var(--text-secondary);
			font-size: 0.92rem;
			margin-bottom: 2.2rem;
		}

		.card {
			background: var(--glass-bg);
			border: 1px solid var(--glass-border);
			border-radius: 16px;
			padding: 1.6rem;
			margin-bottom: 1.5rem;
			backdrop-filter: blur(20px);
		}

		.card-header {
			display: flex;
			align-items: center;
			justify-content: space-between;
			margin-bottom: 1.1rem;
			gap: 1rem;
		}

		.card-title {
			font-family: 'Syne', sans-serif;
			font-weight: 600;
			font-size: 1.05rem;
		}

		.badge-soon {
			font-size: 0.68rem;
			letter-spacing: 0.06em;
			text-transform: uppercase;
			color: var(--text-muted);
			border: 1px solid var(--glass-border);
			border-radius: 999px;
			padding: 3px 9px;
		}

		/* ── Metadata form (stub — no backend yet) ── */
		.meta-form { display: flex; flex-direction: column; gap: 1rem; }

		.field-label {
			display: block;
			font-size: 0.78rem;
			color: var(--text-muted);
			margin-bottom: 0.4rem;
			text-transform: uppercase;
			letter-spacing: 0.05em;
		}

		.field-input {
			width: 100%;
			background: rgba(255, 255, 255, 0.03);
			border: 1px solid var(--glass-border);
			border-radius: 8px;
			padding: 0.6rem 0.8rem;
			color: var(--text-primary);
			font-family: 'DM Sans', sans-serif;
			font-size: 0.9rem;
		}
		.field-input:disabled { color: var(--text-secondary); cursor: not-allowed; opacity: 0.7; }

		.btn-save {
			align-self: flex-start;
			background: var(--grad);
			border: none;
			border-radius: 8px;
			padding: 0.6rem 1.3rem;
			color: #fff;
			font-family: 'Syne', sans-serif;
			font-weight: 600;
			font-size: 0.85rem;
			cursor: pointer;
			transition: opacity 0.15s, transform 0.15s;
		}
		.btn-save:hover { opacity: 0.9; transform: translateY(-1px); }

		/* ── Song rows ── */
		.track-list { list-style: none; }

		.track-row {
			display: grid;
			grid-template-columns: 1fr 70px 72px;
			gap: 1rem;
			align-items: center;
			padding: 0.65rem 0.5rem;
			border-radius: 8px;
			transition: background 0.15s;
		}
		.track-row:hover { background: rgba(255, 255, 255, 0.05); }
		.track-row + .track-row { border-top: 1px solid var(--glass-border); }

		.track-title {
			font-family: 'Syne', sans-serif;
			font-size: 0.95rem;
			font-weight: 600;
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
		}

		.track-meta {
			margin-top: 2px;
			font-size: 0.78rem;
			color: var(--text-secondary);
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
		}

		.track-duration {
			font-size: 0.85rem;
			color: var(--text-secondary);
			text-align: right;
		}

		.track-actions {
			display: flex;
			gap: 0.4rem;
			justify-content: flex-end;
		}

		.icon-btn {
			width: 32px;
			height: 32px;
			display: flex;
			align-items: center;
			justify-content: center;
			border-radius: 8px;
			border: 1px solid var(--glass-border);
			background: rgba(255, 255, 255, 0.04);
			color: var(--text-secondary);
			cursor: pointer;
			transition: background 0.15s, color 0.15s, border-color 0.15s;
		}
		.icon-btn:hover { color: var(--text-primary); border-color: rgba(255,255,255,0.2); }
		.icon-btn.delete:hover { color: var(--red); border-color: rgba(232,48,42,0.5); background: rgba(232,48,42,0.12); }
		.icon-btn svg { width: 14px; height: 14px; pointer-events: none; }

		.tracklist-empty, .tracklist-loading, .tracklist-error {
			padding: 1rem 0.5rem;
			color: var(--text-muted);
			font-size: 0.88rem;
		}
		.tracklist-error { color: #ff6b5b; }

		/* ── Add song ── */
		.btn-add-song {
			display: inline-flex;
			align-items: center;
			gap: 0.5rem;
			background: rgba(255, 255, 255, 0.04);
			border: 1px dashed var(--glass-border);
			border-radius: 10px;
			padding: 0.8rem 1.1rem;
			color: var(--text-primary);
			font-family: 'Syne', sans-serif;
			font-weight: 600;
			font-size: 0.88rem;
			cursor: pointer;
			width: 100%;
			justify-content: center;
			transition: background 0.15s, border-color 0.15s;
		}
		.btn-add-song:hover { background: rgba(255,255,255,0.07); border-color: rgba(255,255,255,0.22); }
		.btn-add-song svg { width: 15px; height: 15px; }
	</style>
</head>

<body>
	<div class="wrapper">
		<a class="back-link" href="${pageContext.request.contextPath}/artist-details/<c:out value='${artistId}'/>">
			<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M15 18l-6-6 6-6"/></svg>
			Back to profile
		</a>

		<div class="page-title">Manage Artist</div>
		<div class="page-subtitle"><c:out value="${not empty artist.name ? artist.name : 'Artist'}"/></div>

		<!-- 1. Edit artist metadata -->
		<div class="card">
			<div class="card-header">
				<span class="card-title">Artist Details</span>
			</div>
			<p style="color: var(--text-secondary); font-size: 0.88rem; margin-bottom: 1.1rem;">
				Update name, bio, genre, and other profile info.
			</p>
			<button class="btn-save" type="button" onclick="goToEditPage()">Edit Details</button>
		</div>

		<!-- 2. Songs — edit / delete -->
		<div class="card">
			<div class="card-header">
				<span class="card-title">Songs</span>
			</div>
			<ul class="track-list" id="track-list">
				<li class="tracklist-loading">Loading songs…</li>
			</ul>
		</div>

		<!-- 3. Add song -->
		<button class="btn-add-song" type="button" onclick="goToAddSongPage()">
			<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round">
				<path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>
			</svg>
			Add Song
		</button>
	</div>

	<script>
		const CTX = '${pageContext.request.contextPath}';
		let artistId = null;
		(async function init() {
	        const parts = window.location.pathname.split('/');
	        currentArtistId = parts[parts.length - 1];

	        if (!currentArtistId) { showToast('No artist ID in URL.', 'error'); return; }

	        try {
	            const res  = await fetch(`${pageContext.request.contextPath}/api/artists/\${currentArtistId}`);
	            if (!res.ok) throw new Error('Artist not found');
	            artistData = await res.json();
	            populateForm(artistData);
	        } catch (e) {
	            showToast('Failed to load artist data.', 'error');
	        }
	    })();
		/* songService lives on its own origin — not behind this app's context path */
		const SONG_SERVICE_BASE = 'http://localhost:8080/api/songs';

		function el(id) { return document.getElementById(id); }

		function formatDuration(raw) {
			if (raw === null || raw === undefined || raw === '') return '--:--';
			let totalSeconds = Number(raw);
			if (isNaN(totalSeconds)) return '--:--';
			if (totalSeconds > 1000) totalSeconds = Math.round(totalSeconds / 1000);
			const minutes = Math.floor(totalSeconds / 60);
			const seconds = Math.floor(totalSeconds % 60);
			return minutes + ':' + String(seconds).padStart(2, '0');
		}

		function songTitle(song) { return song.songName || 'Untitled'; }
		function songMeta(song) { return song.albumName || ''; }

		function goToEditPage() {
			if (!currentArtistId) return;
			window.location.href = CTX + '/artist/edit/' + currentArtistId;
		}

		function goToAddSongPage() {
			if (!currentArtistId) return;
			window.location.href = CTX + '/artist-details/' + currentArtistId + '/add-song';
		}

		function goToEditSongPage(song) {
			if (!currentArtistId) return;
			window.location.href = CTX + '/artist-details/' + currentArtistId + '/edit-song/' + song.id;
		}

		function deleteSong(song, rowEl) {
			const confirmed = window.confirm('Delete "' + songTitle(song) + '"? This can\'t be undone.');
			if (!confirmed) return;

			fetch(SONG_SERVICE_BASE + '/' + song.id, { method: 'DELETE' })
				.then(res => {
					if (!res.ok) throw new Error('Request failed with status ' + res.status);
					return res.text();
				})
				.then(() => {
					rowEl.remove();
					const list = el('track-list');
					if (list && list.children.length === 0) {
						const empty = document.createElement('li');
						empty.className = 'tracklist-empty';
						empty.textContent = 'No songs added yet.';
						list.appendChild(empty);
					}
				})
				.catch(err => {
					console.error('Failed to delete song: ', err);
					window.alert('Could not delete this song right now. Please try again.');
				});
		}

		function renderTrackRow(song) {
			const li = document.createElement('li');
			li.className = 'track-row';

			const mainDiv = document.createElement('div');
			const titleDiv = document.createElement('div');
			titleDiv.className = 'track-title';
			titleDiv.textContent = songTitle(song);
			mainDiv.appendChild(titleDiv);

			const meta = songMeta(song);
			if (meta) {
				const metaDiv = document.createElement('div');
				metaDiv.className = 'track-meta';
				metaDiv.textContent = meta;
				mainDiv.appendChild(metaDiv);
			}

			const durSpan = document.createElement('span');
			durSpan.className = 'track-duration';
			durSpan.textContent = formatDuration(song.duration);

			const actions = document.createElement('div');
			actions.className = 'track-actions';

			const editBtn = document.createElement('button');
			editBtn.className = 'icon-btn';
			editBtn.type = 'button';
			editBtn.setAttribute('aria-label', 'Edit song');
			editBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>';
			editBtn.addEventListener('click', () => goToEditSongPage(song));

			const deleteBtn = document.createElement('button');
			deleteBtn.className = 'icon-btn delete';
			deleteBtn.type = 'button';
			deleteBtn.setAttribute('aria-label', 'Delete song');
			deleteBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>';
			deleteBtn.addEventListener('click', () => deleteSong(song, li));

			actions.appendChild(editBtn);
			actions.appendChild(deleteBtn);

			li.appendChild(mainDiv);
			li.appendChild(durSpan);
			li.appendChild(actions);
			return li;
		}

		function loadArtistSongs() {
			const list = el('track-list');
			if (!list || !currentArtistId) return;

			fetch(SONG_SERVICE_BASE + '/artist/' + encodeURIComponent(currentArtistId))
				.then(res => {
					if (!res.ok) throw new Error('Request failed with status ' + res.status);
					return res.json();
				})
				.then(songs => {
					list.innerHTML = '';
					if (!Array.isArray(songs) || songs.length === 0) {
						const empty = document.createElement('li');
						empty.className = 'tracklist-empty';
						empty.textContent = 'No songs added yet.';
						list.appendChild(empty);
						return;
					}
					songs.forEach(song => list.appendChild(renderTrackRow(song)));
				})
				.catch(err => {
					console.error('Failed to load songs: ', err);
					list.innerHTML = '';
					const errorEl = document.createElement('li');
					errorEl.className = 'tracklist-error';
					errorEl.textContent = 'Could not load songs right now.';
					list.appendChild(errorEl);
				});
		}

		document.addEventListener('DOMContentLoaded', loadArtistSongs);
	</script>
</body>
</html>
