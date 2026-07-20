<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageLessons.aspx.cs" Inherits="HangeulHubWAPP.Instructor.ManageLessons" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Lessons - HangeulHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet" />

    <style>
        * { box-sizing: border-box; }
        body { font-family: Poppins, Arial, sans-serif; background: #f4f4fc; margin: 0; color: #222; }

        /* ---------- Topbar ---------- */
        .topbar {
            background: white; padding: 18px 40px; display: flex;
            justify-content: space-between; align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,.05);
        }
        .topbar h2 { margin: 0; color: #7c5cfc; }
        .topbar a {
            text-decoration: none; background: #7c5cfc; color: white;
            padding: 10px 18px; border-radius: 10px; font-weight: 500;
            transition: background .2s;
        }
        .topbar a:hover { background: #6847e8; }

        .container { max-width: 1150px; margin: auto; padding: 35px 25px 90px; }

        /* ---------- Dashboard stats ---------- */
        .stats { display: flex; gap: 18px; flex-wrap: wrap; margin-bottom: 28px; }
        .stat-card {
            flex: 1 1 200px; background: white; border-radius: 18px; padding: 22px 24px;
            box-shadow: 0 4px 15px rgba(0,0,0,.06); position: relative; overflow: hidden;
        }
        .stat-card::before {
            content: ""; position: absolute; top: 0; left: 0; right: 0; height: 5px;
            background: linear-gradient(90deg, #7c5cfc, #a78bfa);
        }
        .stat-card.beginner::before     { background: linear-gradient(90deg, #7c5cfc, #c4b5fd); }
        .stat-card.intermediate::before { background: linear-gradient(90deg, #3b82f6, #93c5fd); }
        .stat-card.advanced::before     { background: linear-gradient(90deg, #10b981, #6ee7b7); }
        .stat-card .stat-label { font-size: 13px; font-weight: 500; color: #888; }
        .stat-card .stat-value { font-size: 34px; font-weight: 700; margin-top: 4px; }

        /* ---------- Toolbar (filters + search) ---------- */
        .toolbar {
            display: flex; justify-content: space-between; align-items: center;
            gap: 16px; flex-wrap: wrap; margin-bottom: 22px;
        }
        .filters { display: flex; gap: 8px; flex-wrap: wrap; }
        .filter-btn {
            border: 1px solid #e2e0f5; background: white; color: #555;
            padding: 8px 18px; border-radius: 999px; cursor: pointer;
            font-family: Poppins; font-size: 14px; font-weight: 500;
            transition: all .2s;
        }
        .filter-btn:hover { border-color: #7c5cfc; color: #7c5cfc; }
        .filter-btn.active { background: #7c5cfc; border-color: #7c5cfc; color: white; }
        .search-box {
            padding: 10px 16px; border: 1px solid #e2e0f5; border-radius: 999px;
            font-family: Poppins; font-size: 14px; width: 260px; background: white;
        }
        .search-box:focus { outline: 2px solid #7c5cfc33; border-color: #7c5cfc; }

        /* ---------- Lesson cards ---------- */
        .lesson-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
        }
        .lesson-card {
            background: white; border-radius: 18px; overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,.06);
            transition: transform .2s ease, box-shadow .2s ease;
            display: flex; flex-direction: column;
        }
        .lesson-card:hover { transform: translateY(-5px); box-shadow: 0 14px 30px rgba(124,92,252,.18); }
        .lesson-head {
            padding: 18px 22px; display: flex; align-items: center; gap: 14px;
            background: linear-gradient(135deg, #f6f4ff, #ffffff);
            border-bottom: 1px solid #f0eefc;
        }
        .lesson-glyph {
            width: 46px; height: 46px; border-radius: 12px; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; font-weight: 700; color: white;
            background: linear-gradient(135deg, #7c5cfc, #a78bfa);
        }
        .lesson-title { font-weight: 600; font-size: 16px; margin: 0; }
        .lesson-meta { font-size: 12px; color: #999; margin-top: 2px; }
        .lesson-body { padding: 16px 22px; flex: 1; }
        .lesson-excerpt { color: #666; font-size: 14px; line-height: 1.55; margin: 10px 0 0; }
        .badge {
            display: inline-block; padding: 4px 12px; border-radius: 999px;
            font-size: 12px; font-weight: 600;
        }
        .badge.beginner     { background: #efe9ff; color: #7c5cfc; }
        .badge.intermediate { background: #e3efff; color: #2f6fdb; }
        .badge.advanced     { background: #e1f8ef; color: #0d9668; }
        .badge.type { background: #f4f4f6; color: #666; margin-left: 6px; }
        .lesson-actions {
            display: flex; gap: 8px; padding: 14px 22px 18px; border-top: 1px solid #f5f4fb;
        }
        .icon-btn {
            flex: 1; border: none; border-radius: 10px; padding: 9px 0;
            font-family: Poppins; font-size: 13px; font-weight: 500; cursor: pointer;
            transition: filter .15s; text-align: center; text-decoration: none;
        }
        .icon-btn:hover { filter: brightness(.94); }
        .icon-btn.edit    { background: #efe9ff; color: #7c5cfc; }
        .icon-btn.preview { background: #eef4ff; color: #2f6fdb; }
        .icon-btn.delete  { background: #ffeef3; color: #e0447c; }

        /* ---------- Empty state ---------- */
        .empty-state {
            text-align: center; padding: 70px 20px; background: white;
            border-radius: 18px; box-shadow: 0 4px 15px rgba(0,0,0,.06);
        }
        .empty-state .emoji { font-size: 46px; }
        .empty-state h3 { margin: 14px 0 4px; }
        .empty-state p { color: #888; margin: 0; }

        /* ---------- Floating new-lesson button ---------- */
        .fab {
            position: fixed; right: 34px; bottom: 34px; z-index: 40;
            background: linear-gradient(135deg, #7c5cfc, #6847e8); color: white;
            border: none; border-radius: 999px; padding: 15px 26px;
            font-family: Poppins; font-size: 15px; font-weight: 600; cursor: pointer;
            box-shadow: 0 10px 25px rgba(124,92,252,.4);
            transition: transform .2s, box-shadow .2s;
        }
        .fab:hover { transform: translateY(-3px); box-shadow: 0 14px 30px rgba(124,92,252,.5); }

        /* ---------- Modals ---------- */
        .modal-overlay {
            display: none; position: fixed; inset: 0; z-index: 100;
            background: rgba(30, 25, 60, .45); backdrop-filter: blur(2px);
            align-items: center; justify-content: center; padding: 20px;
        }
        .modal-overlay.open { display: flex; }
        .modal {
            background: white; border-radius: 18px; width: 100%; max-width: 520px;
            padding: 28px; box-shadow: 0 25px 60px rgba(0,0,0,.25);
            max-height: 90vh; overflow-y: auto;
        }
        .modal h3 { margin: 0 0 6px; color: #7c5cfc; }
        .modal .modal-sub { color: #888; font-size: 13px; margin: 0 0 14px; }
        .modal label { display: block; margin: 14px 0 6px; font-weight: 600; font-size: 14px; }
        .modal input, .modal select, .modal textarea {
            width: 100%; padding: 10px 12px; border: 1px solid #ddd;
            border-radius: 10px; font-family: Poppins; font-size: 14px;
        }
        .modal textarea { min-height: 130px; resize: vertical; }
        .modal-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 22px; }
        .btn {
            border: none; border-radius: 10px; padding: 11px 22px; cursor: pointer;
            font-family: Poppins; font-weight: 600; font-size: 14px; transition: filter .15s;
        }
        .btn:hover { filter: brightness(.93); }
        .btn.primary { background: #7c5cfc; color: white; }
        .btn.ghost   { background: #f1f0fa; color: #555; }
        .btn.danger  { background: #e0447c; color: white; }
        .modal .warn-icon { font-size: 38px; }
        .preview-content {
            background: #faf9ff; border: 1px solid #efeefb; border-radius: 12px;
            padding: 16px; font-size: 14px; line-height: 1.6; color: #444;
            white-space: pre-wrap; max-height: 320px; overflow-y: auto; margin-top: 12px;
        }
        .msg { display: block; margin-top: 10px; font-size: 14px; font-weight: 500; }

        .hidden-content { display: none; }

        /* ---------- Responsive ---------- */
        @media (max-width: 720px) {
            .topbar { padding: 14px 18px; }
            .toolbar { flex-direction: column; align-items: stretch; }
            .search-box { width: 100%; }
            .lesson-grid { grid-template-columns: 1fr; }
            .fab { right: 18px; bottom: 18px; }
        }
        @media (prefers-reduced-motion: reduce) {
            * { transition: none !important; }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <div class="topbar">
        <h2>Manage Lessons</h2>
        <a href="InstructorDashboard.aspx">Back to Dashboard</a>
    </div>

    <main class="container">

        <!-- ========== Dashboard statistics ========== -->
        <div class="stats">
            <div class="stat-card">
                <div class="stat-label">Total Lessons</div>
                <div class="stat-value"><asp:Literal ID="litTotal" runat="server">0</asp:Literal></div>
            </div>
            <div class="stat-card beginner">
                <div class="stat-label">Beginner</div>
                <div class="stat-value"><asp:Literal ID="litBeginner" runat="server">0</asp:Literal></div>
            </div>
            <div class="stat-card intermediate">
                <div class="stat-label">Intermediate</div>
                <div class="stat-value"><asp:Literal ID="litIntermediate" runat="server">0</asp:Literal></div>
            </div>
            <div class="stat-card advanced">
                <div class="stat-label">Advanced</div>
                <div class="stat-value"><asp:Literal ID="litAdvanced" runat="server">0</asp:Literal></div>
            </div>
        </div>

        <!-- ========== Search + filters ========== -->
        <div class="toolbar">
            <div class="filters">
                <button type="button" class="filter-btn active" data-level="all" onclick="setFilter(this)">All</button>
                <button type="button" class="filter-btn" data-level="beginner" onclick="setFilter(this)">Beginner</button>
                <button type="button" class="filter-btn" data-level="intermediate" onclick="setFilter(this)">Intermediate</button>
                <button type="button" class="filter-btn" data-level="advanced" onclick="setFilter(this)">Advanced</button>
            </div>
            <input type="search" id="searchBox" class="search-box" placeholder="Search lessons..."
                   oninput="applyFilters()" onkeydown="if(event.key==='Enter'){event.preventDefault();}" />
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="msg"></asp:Label>

        <!-- ========== Lesson cards ========== -->
        <div class="lesson-grid" id="lessonGrid">
            <asp:Repeater ID="rptLessons" runat="server" OnItemCommand="rptLessons_ItemCommand">
                <ItemTemplate>
                    <div class="lesson-card"
                         data-level='<%# GetLevelKey(Eval("courseID")) %>'
                         data-lessonid='<%#: Eval("lessonID") %>'
                         data-title='<%#: GetLessonTitle(Eval("type")) %>'
                         data-course='<%#: GetLevelName(Eval("courseID")) %>'>
                        <div class="lesson-head">
                            <div class="lesson-glyph"><%# GetTypeGlyph(Eval("type")) %></div>
                            <div>
                                <p class="lesson-title"><%#: GetLessonTitle(Eval("type")) %></p>
                                <div class="lesson-meta"><%#: Eval("lessonID") %></div>
                            </div>
                        </div>
                        <div class="lesson-body">
                            <span class='badge <%# GetLevelKey(Eval("courseID")) %>'>
                                <%# GetLevelDot(Eval("courseID")) %> <%#: GetLevelName(Eval("courseID")) %>
                            </span>
                            <span class="badge type"><%#: Eval("type") %></span>
                            <p class="lesson-excerpt"><%#: GetPreview(Eval("content")) %></p>
                            <div class="hidden-content js-full-content"><%#: Eval("content") %></div>
                        </div>
                        <div class="lesson-actions">
                            <asp:LinkButton ID="btnEdit" runat="server" CssClass="icon-btn edit"
                                CommandName="EditLesson" CommandArgument='<%# Eval("lessonID") %>'>
                                &#9998; Edit
                            </asp:LinkButton>
                            <button type="button" class="icon-btn preview" onclick="openPreview(this)">&#128065; Preview</button>
                            <button type="button" class="icon-btn delete" onclick="openDelete(this)">&#128465; Delete</button>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Empty state: no lessons in the database at all -->
        <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty-state" Visible="false">
            <div class="emoji">&#128218;</div>
            <h3>No lessons yet</h3>
            <p>Create your first lesson to get started.</p>
        </asp:Panel>

        <!-- Empty state: search/filter found nothing (client-side) -->
        <div id="noResults" class="empty-state" style="display:none;">
            <div class="emoji">&#128269;</div>
            <h3>No lessons found</h3>
            <p>Try a different search or filter.</p>
        </div>
    </main>

    <button type="button" class="fab" onclick="openLessonModal()">+ New Lesson</button>

    <!-- ========== Create / edit lesson modal ========== -->
    <div class="modal-overlay" id="lessonModal">
        <div class="modal">
            <h3 id="lessonModalTitle">New Lesson</h3>
            <p class="modal-sub">The lesson title is generated automatically from the lesson type.</p>
            <asp:HiddenField ID="hfLessonID" runat="server" />

            <label>Course Level</label>
            <asp:DropDownList ID="ddlCourse" runat="server">
                <asp:ListItem Value="C001">Beginner Korean</asp:ListItem>
                <asp:ListItem Value="C002">Intermediate Korean</asp:ListItem>
                <asp:ListItem Value="C003">Advanced Korean</asp:ListItem>
            </asp:DropDownList>

            <label>Lesson Type</label>
            <asp:DropDownList ID="ddlType" runat="server">
                <asp:ListItem>Hangul</asp:ListItem>
                <asp:ListItem>Vocabulary</asp:ListItem>
                <asp:ListItem>Grammar</asp:ListItem>
            </asp:DropDownList>

            <label>Lesson Content</label>
            <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine"></asp:TextBox>

            <asp:Label ID="lblModalMessage" runat="server" CssClass="msg"></asp:Label>

            <div class="modal-actions">
                <button type="button" class="btn ghost" onclick="closeModal('lessonModal')">Cancel</button>
                <asp:Button ID="btnSaveLesson" runat="server" Text="Save Lesson"
                    CssClass="btn primary" OnClick="btnSaveLesson_Click" />
            </div>
        </div>
    </div>

    <!-- ========== Preview modal (client-side only) ========== -->
    <div class="modal-overlay" id="previewModal">
        <div class="modal">
            <h3 id="previewTitle">Lesson Preview</h3>
            <p class="modal-sub" id="previewMeta"></p>
            <div class="preview-content" id="previewBody"></div>
            <div class="modal-actions">
                <button type="button" class="btn ghost" onclick="closeModal('previewModal')">Close</button>
            </div>
        </div>
    </div>

    <!-- ========== Delete confirmation modal ========== -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal" style="max-width:420px; text-align:center;">
            <div class="warn-icon">&#9888;&#65039;</div>
            <h3 style="color:#e0447c;">Delete Lesson</h3>
            <p class="modal-sub" id="deleteText">Are you sure you want to delete this lesson? This cannot be undone.</p>
            <asp:HiddenField ID="hfDeleteID" runat="server" />
            <div class="modal-actions" style="justify-content:center;">
                <button type="button" class="btn ghost" onclick="closeModal('deleteModal')">Cancel</button>
                <asp:Button ID="btnConfirmDelete" runat="server" Text="Delete"
                    CssClass="btn danger" OnClick="btnConfirmDelete_Click" />
            </div>
        </div>
    </div>

    <script>
        /* ---------- Modal helpers ---------- */
        function openModal(id) { document.getElementById(id).classList.add('open'); }
        function closeModal(id) { document.getElementById(id).classList.remove('open'); }

        function openLessonModal() {
            document.getElementById('lessonModalTitle').textContent = 'New Lesson';
            document.getElementById('<%= hfLessonID.ClientID %>').value = '';
            openModal('lessonModal');
        }
        // Called from server via RegisterStartupScript when editing / validation fails
        function openLessonModalAs(title) {
            document.getElementById('lessonModalTitle').textContent = title;
            openModal('lessonModal');
        }

        /* ---------- Preview ---------- */
        function openPreview(btn) {
            var card = btn.closest('.lesson-card');
            document.getElementById('previewTitle').textContent = card.dataset.title;
            document.getElementById('previewMeta').textContent =
                card.dataset.course + ' \u00B7 ' + card.dataset.lessonid;
            document.getElementById('previewBody').textContent =
                card.querySelector('.js-full-content').textContent;
            openModal('previewModal');
        }

        /* ---------- Delete ---------- */
        function openDelete(btn) {
            var card = btn.closest('.lesson-card');
            document.getElementById('<%= hfDeleteID.ClientID %>').value = card.dataset.lessonid;
            document.getElementById('deleteText').textContent =
                'Are you sure you want to delete "' + card.dataset.title +
                '" (' + card.dataset.lessonid + ')? This cannot be undone.';
            openModal('deleteModal');
        }

        /* ---------- Search + filter ---------- */
        var activeLevel = 'all';

        function setFilter(btn) {
            document.querySelectorAll('.filter-btn').forEach(function (b) { b.classList.remove('active'); });
            btn.classList.add('active');
            activeLevel = btn.dataset.level;
            applyFilters();
        }

        function applyFilters() {
            var q = document.getElementById('searchBox').value.trim().toLowerCase();
            var cards = document.querySelectorAll('.lesson-card');
            var visible = 0;
            cards.forEach(function (card) {
                var matchLevel = (activeLevel === 'all' || card.dataset.level === activeLevel);
                var haystack = (card.dataset.title + ' ' + card.dataset.course + ' ' +
                    card.textContent).toLowerCase();
                var matchSearch = (q === '' || haystack.indexOf(q) !== -1);
                var show = matchLevel && matchSearch;
                card.style.display = show ? '' : 'none';
                if (show) visible++;
            });
            var noResults = document.getElementById('noResults');
            if (noResults) noResults.style.display = (cards.length > 0 && visible === 0) ? '' : 'none';
        }

        // Close modal when clicking the dark overlay
        document.querySelectorAll('.modal-overlay').forEach(function (ov) {
            ov.addEventListener('mousedown', function (e) {
                if (e.target === ov) ov.classList.remove('open');
            });
        });
    </script>

</form>
</body>
</html>