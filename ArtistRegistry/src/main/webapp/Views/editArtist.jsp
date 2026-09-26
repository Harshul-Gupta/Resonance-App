<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Edit Artist — Resonance</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
    <style>
        :root {
            --bg-deep:      #0b0d14;
            --bg-card:      rgba(255,255,255,0.045);
            --border:       rgba(255,255,255,0.10);
            --border-focus: rgba(139,92,246,0.70);
            --accent:       #8b5cf6;
            --accent-soft:  rgba(139,92,246,0.18);
            --accent-glow:  rgba(139,92,246,0.35);
            --danger:       #ef4444;
            --danger-soft:  rgba(239,68,68,0.15);
            --danger-glow:  rgba(239,68,68,0.35);
            --text-primary: #e8e6f0;
            --text-muted:   #7b7a8e;
            --text-label:   #a09eb8;
            --glass-blur:   blur(18px);
            --radius-card:  18px;
            --radius-input: 10px;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background: var(--bg-deep);
            color: var(--text-primary);
            font-family: 'Inter', system-ui, sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* ── Ambient orbs ─────────────────────────────────────── */
        .orb {
            position: fixed;
            border-radius: 50%;
            filter: blur(90px);
            pointer-events: none;
            z-index: 0;
            opacity: 0.28;
        }
        .orb-1 { width: 520px; height: 520px; background: #6d28d9; top: -120px; left: -160px; }
        .orb-2 { width: 400px; height: 400px; background: #1e1b4b; bottom: -80px; right: -100px; }
        .orb-3 { width: 260px; height: 260px; background: #4c1d95; top: 48%; left: 55%; }

        /* ── Nav ──────────────────────────────────────────────── */
        nav {
            position: sticky;
            top: 0;
            z-index: 50;
            background: rgba(11,13,20,0.72);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            padding: 0 2rem;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .nav-brand {
            font-size: 1.2rem;
            font-weight: 700;
            letter-spacing: 0.05em;
            background: linear-gradient(135deg, #c4b5fd, #8b5cf6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-decoration: none;
        }
        .nav-back {
            display: flex;
            align-items: center;
            gap: 6px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.85rem;
            transition: color 0.2s;
        }
        .nav-back:hover { color: var(--text-primary); }
        .nav-back svg { width: 16px; height: 16px; }

        /* ── Page layout ──────────────────────────────────────── */
        .page {
            position: relative;
            z-index: 1;
            max-width: 720px;
            margin: 0 auto;
            padding: 3rem 1.5rem 5rem;
        }

        .page-header {
            margin-bottom: 2.2rem;
        }
        .page-eyebrow {
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            color: var(--accent);
            margin-bottom: 0.5rem;
        }
        .page-title {
            font-size: 1.9rem;
            font-weight: 700;
            color: var(--text-primary);
            line-height: 1.2;
        }
        .page-subtitle {
            font-size: 0.88rem;
            color: var(--text-muted);
            margin-top: 0.4rem;
        }
        #artist-name-display {
            color: var(--accent);
        }

        /* ── Glass card ───────────────────────────────────────── */
        .card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-card);
            backdrop-filter: var(--glass-blur);
            padding: 2rem 2.2rem;
        }

        /* ── Form ─────────────────────────────────────────────── */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.2rem 1.4rem;
        }
        .form-group { display: flex; flex-direction: column; gap: 0.45rem; }
        .form-group.full { grid-column: 1 / -1; }

        label {
            font-size: 0.78rem;
            font-weight: 600;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--text-label);
        }

        input[type="text"],
        select,
        textarea {
            background: rgba(255,255,255,0.05);
            border: 1px solid var(--border);
            border-radius: var(--radius-input);
            padding: 0.65rem 0.9rem;
            color: var(--text-primary);
            font-family: inherit;
            font-size: 0.92rem;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
            width: 100%;
        }
        input[type="text"]:focus,
        select:focus,
        textarea:focus {
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px var(--accent-soft);
            background: rgba(139,92,246,0.07);
        }
        select option { background: #1a1a2e; }
        textarea { resize: vertical; min-height: 100px; line-height: 1.55; }

        /* Genre chips ------------------------------------------ */
        .genre-chips {
            display: flex;
            flex-wrap: wrap;
            gap: 0.45rem;
            padding: 0.6rem 0.8rem;
            background: rgba(255,255,255,0.05);
            border: 1px solid var(--border);
            border-radius: var(--radius-input);
            min-height: 44px;
            cursor: text;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .genre-chips:focus-within {
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px var(--accent-soft);
        }
        .chip {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 3px 10px 3px 11px;
            background: var(--accent-soft);
            border: 1px solid rgba(139,92,246,0.3);
            border-radius: 99px;
            font-size: 0.8rem;
            color: #c4b5fd;
            white-space: nowrap;
        }
        .chip-remove {
            background: none;
            border: none;
            color: #a78bfa;
            cursor: pointer;
            font-size: 1rem;
            line-height: 1;
            padding: 0 1px;
            transition: color 0.15s;
        }
        .chip-remove:hover { color: #ef4444; }
        .genre-input {
            border: none !important;
            outline: none !important;
            background: transparent !important;
            box-shadow: none !important;
            color: var(--text-primary);
            font-size: 0.9rem;
            min-width: 100px;
            flex: 1;
            padding: 3px 4px !important;
        }
        .genre-hint {
            font-size: 0.74rem;
            color: var(--text-muted);
            margin-top: 0.3rem;
        }

        /* Image upload zone ------------------------------------ */
        .image-upload-zone {
            position: relative;
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.8rem;
            background: rgba(255,255,255,0.04);
            border: 1px dashed var(--border);
            border-radius: var(--radius-input);
            cursor: pointer;
            transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
        }
        .image-upload-zone:hover {
            border-color: rgba(139,92,246,0.45);
            background: rgba(139,92,246,0.05);
        }
        .image-upload-zone.drag-over {
            border-color: var(--accent);
            background: rgba(139,92,246,0.1);
            box-shadow: 0 0 0 3px var(--accent-soft);
        }
        .image-upload-zone.has-new-image {
            border-style: solid;
            border-color: rgba(139,92,246,0.5);
        }
        .img-thumb {
            width: 62px;
            height: 62px;
            border-radius: 10px;
            object-fit: cover;
            border: 1px solid var(--border);
            flex-shrink: 0;
            background: rgba(255,255,255,0.06);
        }
        .img-note {
            font-size: 0.8rem;
            color: var(--text-muted);
            line-height: 1.5;
            display: flex;
            flex-direction: column;
        }
        .img-note strong { color: var(--text-label); margin-bottom: 2px; }
        .img-clear-btn {
            margin-left: auto;
            background: rgba(239,68,68,0.12);
            border: 1px solid rgba(239,68,68,0.3);
            color: #fca5a5;
            width: 26px;
            height: 26px;
            border-radius: 50%;
            font-size: 1rem;
            line-height: 1;
            cursor: pointer;
            flex-shrink: 0;
            transition: background 0.2s;
        }
        .img-clear-btn:hover { background: rgba(239,68,68,0.25); }

        /* Divider --------------------------------------------- */
        .section-divider {
            border: none;
            border-top: 1px solid var(--border);
            margin: 1.8rem 0;
        }

        /* Action bar ------------------------------------------ */
        .actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 0.65rem 1.4rem;
            border-radius: 10px;
            font-size: 0.88rem;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: opacity 0.2s, transform 0.15s, box-shadow 0.2s;
            text-decoration: none;
        }
        .btn:disabled { opacity: 0.5; cursor: not-allowed; }
        .btn:not(:disabled):hover { transform: translateY(-1px); }
        .btn:not(:disabled):active { transform: translateY(0); }

        .btn-primary {
            background: linear-gradient(135deg, #7c3aed, #5b21b6);
            color: #fff;
            box-shadow: 0 4px 16px rgba(109,40,217,0.4);
        }
        .btn-primary:not(:disabled):hover {
            box-shadow: 0 6px 24px rgba(109,40,217,0.55);
        }
        .btn-ghost {
            background: rgba(255,255,255,0.07);
            border: 1px solid var(--border);
            color: var(--text-muted);
        }
        .btn-ghost:hover { color: var(--text-primary); background: rgba(255,255,255,0.11); }

        .btn-danger {
            background: var(--danger-soft);
            border: 1px solid rgba(239,68,68,0.25);
            color: #fca5a5;
        }
        .btn-danger:not(:disabled):hover {
            background: rgba(239,68,68,0.25);
            box-shadow: 0 4px 16px var(--danger-glow);
            color: #fff;
        }

        /* Toast ----------------------------------------------- */
        #toast {
            position: fixed;
            bottom: 2rem;
            left: 50%;
            transform: translateX(-50%) translateY(20px);
            background: rgba(30,27,75,0.92);
            border: 1px solid var(--border);
            backdrop-filter: blur(16px);
            color: var(--text-primary);
            padding: 0.75rem 1.4rem;
            border-radius: 12px;
            font-size: 0.87rem;
            white-space: nowrap;
            z-index: 999;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.25s, transform 0.25s;
        }
        #toast.show {
            opacity: 1;
            transform: translateX(-50%) translateY(0);
        }
        #toast.success { border-color: rgba(139,92,246,0.45); }
        #toast.error   { border-color: rgba(239,68,68,0.45); color: #fca5a5; }

        /* Delete confirm modal -------------------------------- */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.6);
            backdrop-filter: blur(4px);
            z-index: 200;
            align-items: center;
            justify-content: center;
        }
        .modal-overlay.open { display: flex; }
        .modal {
            background: #13132a;
            border: 1px solid rgba(239,68,68,0.25);
            border-radius: 16px;
            padding: 2rem;
            max-width: 400px;
            width: calc(100% - 2rem);
            text-align: center;
        }
        .modal-icon { font-size: 2rem; margin-bottom: 0.8rem; }
        .modal h3 { font-size: 1.1rem; font-weight: 700; margin-bottom: 0.5rem; }
        .modal p  { font-size: 0.87rem; color: var(--text-muted); margin-bottom: 1.5rem; line-height: 1.6; }
        .modal-actions { display: flex; gap: 0.75rem; justify-content: center; }

        /* Loading spinner ------------------------------------- */
        .spinner {
            width: 16px; height: 16px;
            border: 2px solid rgba(255,255,255,0.3);
            border-top-color: #fff;
            border-radius: 50%;
            animation: spin 0.6s linear infinite;
            display: none;
        }
        .loading .spinner { display: inline-block; }
        .loading .btn-text { display: none; }
        @keyframes spin { to { transform: rotate(360deg); } }

        @media (max-width: 600px) {
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full { grid-column: 1; }
            .card { padding: 1.4rem 1.2rem; }
            .actions { flex-direction: column-reverse; align-items: stretch; }
            .btn { justify-content: center; }
        }
    </style>
</head>
<body>

<!-- Ambient orbs -->
<div class="orb orb-1"></div>
<div class="orb orb-2"></div>
<div class="orb orb-3"></div>

<!-- Nav -->
<nav>
    <a href="${pageContext.request.contextPath}/" class="nav-brand">Resonance</a>
    <a href="javascript:history.back()" class="nav-back">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M19 12H5M12 19l-7-7 7-7"/>
        </svg>
        Back
    </a>
</nav>

<!-- Page -->
<div class="page">
    <div class="page-header">
        <p class="page-eyebrow">Artist Management</p>
        <h1 class="page-title">Edit Artist</h1>
        <p class="page-subtitle">Editing <span id="artist-name-display">—</span></p>
    </div>

    <div class="card">
        <div class="form-grid" id="edit-form">

            <!-- Name -->
            <div class="form-group">
                <label for="name">Artist Name</label>
                <input type="text" id="name" placeholder="e.g. Radiohead" />
            </div>

            <!-- Type -->
            <div class="form-group">
                <label for="type">Type</label>
                <select id="type">
                    <option value="">— Select —</option>
                    <option value="solo">Solo</option>
                    <option value="band">Band</option>
                    <option value="duo">Duo</option>
                </select>
            </div>

            <!-- Country -->
            <div class="form-group">
                <label for="country">Country</label>
                <input type="text" id="country" placeholder="e.g. United Kingdom" />
            </div>

            <!-- Genre -->
            <div class="form-group">
                <label>Genres</label>
                <div class="genre-chips" id="genre-chips" onclick="document.getElementById('genre-text').focus()">
                    <!-- chips injected here -->
                    <input type="text" id="genre-text" class="genre-input" placeholder="Type and press Enter…" />
                </div>
                <span class="genre-hint">Press <kbd>Enter</kbd> or <kbd>,</kbd> to add a genre.</span>
            </div>

            <!-- Bio -->
            <div class="form-group full">
                <label for="bio">Bio</label>
                <textarea id="bio" placeholder="A short biography of the artist…"></textarea>
            </div>

            <!-- Image (editable) -->
            <div class="form-group full">
                <label>Artist Image</label>
                <div class="image-upload-zone" id="image-upload-zone">
                    <img id="img-thumb" class="img-thumb" src="" alt="Artist image" />
                    <div class="img-note">
                        <strong id="img-note-title">Current image</strong>
                        <span id="img-note-sub">Click or drag a new photo here to replace it.</span>
                    </div>
                    <button type="button" class="img-clear-btn" id="img-clear-btn" title="Revert to current image" style="display:none">
                        &times;
                    </button>
                </div>
                <input type="file" id="image-input" accept="image/*" hidden />
            </div>

        </div>

        <hr class="section-divider" />

        <div class="actions">
            <!-- Danger zone: delete -->
            <button class="btn btn-danger" id="delete-btn" onclick="openDeleteModal()">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                    <polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6M14 11v6"/><path d="M9 6V4h6v2"/>
                </svg>
                Delete Artist
            </button>

            <div style="display:flex;gap:0.75rem;">
                <a href="javascript:history.back()" class="btn btn-ghost">Cancel</a>
                <button class="btn btn-primary" id="save-btn" onclick="submitEdit()">
                    <span class="btn-text">Save Changes</span>
                    <div class="spinner"></div>
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Delete confirm modal -->
<div class="modal-overlay" id="delete-modal">
    <div class="modal">
        <div class="modal-icon">⚠️</div>
        <h3>Delete Artist?</h3>
        <p>This will permanently remove <strong id="modal-artist-name">this artist</strong> from Resonance. This action cannot be undone.</p>
        <div class="modal-actions">
            <button class="btn btn-ghost" onclick="closeDeleteModal()">Cancel</button>
            <button class="btn btn-danger" id="confirm-delete-btn" onclick="confirmDelete()">
                <span class="btn-text">Yes, Delete</span>
                <div class="spinner"></div>
            </button>
        </div>
    </div>
</div>

<!-- Toast -->
<div id="toast"></div>

<script>
    /* ─── State ────────────────────────────────────────────── */
    let artistId    = null;
    let genres      = new Set();
    let artistData  = null;
    let selectedFile = null;   // new image chosen by user (null = keep existing)

    /* ─── Bootstrap: read ID from URL, fetch artist ─────────
       URL pattern: /artist/edit/{id}
       Adjust the split index if your context path differs.    */
    (async function init() {
        const parts = window.location.pathname.split('/');
        artistId = parts[parts.length - 1];

        if (!artistId) { showToast('No artist ID in URL.', 'error'); return; }

        try {
            const res  = await fetch(`${pageContext.request.contextPath}/api/artists/\${artistId}`);
            if (!res.ok) throw new Error('Artist not found');
            artistData = await res.json();
            populateForm(artistData);
        } catch (e) {
            showToast('Failed to load artist data.', 'error');
        }
    })();

    /* ─── Populate form fields ───────────────────────────── */
    function populateForm(a) {
        document.getElementById('artist-name-display').textContent = a.name || '—';
        document.getElementById('name').value    = a.name    || '';
        document.getElementById('country').value = a.country || '';
        document.getElementById('bio').value     = a.bio     || '';

        const typeEl = document.getElementById('type');
        if (a.type) typeEl.value = a.type;

        const imgEl = document.getElementById('img-thumb');
        if (a.imageURL) { imgEl.src = a.imageURL; imgEl.style.display = ''; }
        else { imgEl.style.display = 'none'; }

        document.getElementById('img-note-title').textContent = 'Current image';
        document.getElementById('img-note-sub').textContent   = 'Click or drag a new photo here to replace it.';
        document.getElementById('img-clear-btn').style.display = 'none';
        document.getElementById('image-upload-zone').classList.remove('has-new-image');
        selectedFile = null;

        document.getElementById('modal-artist-name').textContent = a.name || 'this artist';

        // Genres
        genres = new Set(a.genre || []);
        renderChips();
    }

    /* ─── Genre chip UI ──────────────────────────────────── */
    function renderChips() {
        const container = document.getElementById('genre-chips');
        const input = document.getElementById('genre-text');
        container.innerHTML = '';
        genres.forEach(g => {
            const chip = document.createElement('span');
            chip.className = 'chip';
            chip.innerHTML = `\${escHtml(g)} <button class="chip-remove" aria-label="Remove \${escHtml(g)}" onclick="removeGenre('\${escHtml(g)}')">&times;</button>`;
            container.appendChild(chip);
        });
        container.appendChild(input);
        input.focus();
    }

    function removeGenre(g) { genres.delete(g); renderChips(); }

    document.addEventListener('DOMContentLoaded', () => {
        const input = document.getElementById('genre-text');
        input.addEventListener('keydown', e => {
            if (e.key === 'Enter' || e.key === ',') {
                e.preventDefault();
                const val = input.value.trim().replace(/,$/, '');
                if (val) { genres.add(val); input.value = ''; renderChips(); }
            } else if (e.key === 'Backspace' && !input.value) {
                const last = [...genres].pop();
                if (last) { genres.delete(last); renderChips(); }
            }
        });

        /* ── Image upload zone wiring ── */
        const zone     = document.getElementById('image-upload-zone');
        const fileInput = document.getElementById('image-input');
        const clearBtn  = document.getElementById('img-clear-btn');

        zone.addEventListener('click', (e) => {
            if (e.target === clearBtn) return;
            fileInput.click();
        });

        fileInput.addEventListener('change', () => {
            if (fileInput.files && fileInput.files[0]) {
                handleNewImage(fileInput.files[0]);
            }
        });

        ['dragenter', 'dragover'].forEach(evt =>
            zone.addEventListener(evt, (e) => {
                e.preventDefault();
                zone.classList.add('drag-over');
            })
        );
        ['dragleave', 'drop'].forEach(evt =>
            zone.addEventListener(evt, (e) => {
                e.preventDefault();
                zone.classList.remove('drag-over');
            })
        );
        zone.addEventListener('drop', (e) => {
            const file = e.dataTransfer.files && e.dataTransfer.files[0];
            if (file && file.type.startsWith('image/')) {
                handleNewImage(file);
            } else if (file) {
                showToast('Please drop an image file.', 'error');
            }
        });

        clearBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            revertImage();
        });
    });

    function handleNewImage(file) {
        selectedFile = file;
        const reader = new FileReader();
        reader.onload = (e) => {
            document.getElementById('img-thumb').src = e.target.result;
            document.getElementById('img-thumb').style.display = '';
        };
        reader.readAsDataURL(file);

        document.getElementById('img-note-title').textContent = 'New image selected';
        document.getElementById('img-note-sub').textContent   = file.name;
        document.getElementById('img-clear-btn').style.display = '';
        document.getElementById('image-upload-zone').classList.add('has-new-image');
    }

    function revertImage() {
        selectedFile = null;
        document.getElementById('image-input').value = '';
        document.getElementById('image-upload-zone').classList.remove('has-new-image');
        document.getElementById('img-clear-btn').style.display = 'none';
        document.getElementById('img-note-title').textContent = 'Current image';
        document.getElementById('img-note-sub').textContent   = 'Click or drag a new photo here to replace it.';

        const imgEl = document.getElementById('img-thumb');
        if (artistData && artistData.imageURL) {
            imgEl.src = artistData.imageURL;
            imgEl.style.display = '';
        } else {
            imgEl.style.display = 'none';
        }
    }

    /* ─── Submit PATCH (multipart: JSON updates + optional file) ── */
    async function submitEdit() {
        const btn  = document.getElementById('save-btn');
        const name = document.getElementById('name').value.trim();
        if (!name) { showToast('Artist name cannot be empty.', 'error'); return; }

        const updates = {
            name:    name,
            type:    document.getElementById('type').value    || undefined,
            country: document.getElementById('country').value.trim() || undefined,
            bio:     document.getElementById('bio').value.trim()     || undefined,
            genre:   [...genres],
        };
        // Remove undefined keys
        Object.keys(updates).forEach(k => updates[k] === undefined && delete updates[k]);

        btn.classList.add('loading');
        btn.disabled = true;

        try {
            const formData = new FormData();

            // "updates" part — must be a JSON blob so Spring's
            // @RequestPart Map<String, Object> can deserialize it
            formData.append(
                'updates',
                new Blob([JSON.stringify(updates)], { type: 'application/json' })
            );

            // "file" part — only attach if the user picked a new image.
            // Backend checks `file != null && !file.isEmpty()`, but
            // @RequestPart MultipartFile is non-optional in the signature,
            // so we still need to send an empty file part when unchanged.
            if (selectedFile) {
                formData.append('file', selectedFile, selectedFile.name);
            } else {
                formData.append('file', new Blob([], { type: 'application/octet-stream' }), '');
            }

            const res = await fetch(`${pageContext.request.contextPath}/api/artists/\${artistId}`, {
                method: 'PATCH',
                body:   formData,
                // NOTE: do NOT set Content-Type manually — the browser
                // sets the correct multipart boundary automatically.
            });

            if (!res.ok) {
                const errText = await res.text();
                throw new Error(errText || 'Update failed');
            }

            const updated = await res.json();
            showToast('Artist updated!', 'success');

            // Redirect to artist detail page after short delay
            setTimeout(() => {
                window.location.href = `${pageContext.request.contextPath}/artist-details/\${artistId}`;
            }, 900);

        } catch (e) {
            showToast(e.message || 'Something went wrong.', 'error');
            btn.classList.remove('loading');
            btn.disabled = false;
        }
    }

    /* ─── Delete ─────────────────────────────────────────── */
    function openDeleteModal()  { document.getElementById('delete-modal').classList.add('open'); }
    function closeDeleteModal() { document.getElementById('delete-modal').classList.remove('open'); }

    async function confirmDelete() {
        const btn = document.getElementById('confirm-delete-btn');
        btn.classList.add('loading');
        btn.disabled = true;

        try {
            const res = await fetch(`${pageContext.request.contextPath}/api/artists/\${artistId}`, {
                method: 'DELETE',
            });
            if (!res.ok) throw new Error('Delete failed');

            showToast('Artist deleted.', 'success');
            setTimeout(() => {
                window.location.href = `${pageContext.request.contextPath}/`;
            }, 900);

        } catch (e) {
            showToast('Could not delete artist.', 'error');
            btn.classList.remove('loading');
            btn.disabled = false;
            closeDeleteModal();
        }
    }

    /* ─── Toast ──────────────────────────────────────────── */
    let toastTimer = null;
    function showToast(msg, type = 'success') {
        const t = document.getElementById('toast');
        t.textContent = msg;
        t.className   = `show \${type}`;
        clearTimeout(toastTimer);
        toastTimer = setTimeout(() => t.className = '', 2800);
    }

    /* ─── Util ───────────────────────────────────────────── */
    function escHtml(str) {
        return String(str).replace(/[&<>"']/g, c =>
            ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
    }
</script>
</body>
</html>
