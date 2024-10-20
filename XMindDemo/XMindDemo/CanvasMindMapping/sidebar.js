function switchSideBar() {
    if (window.getComputedStyle(sidebar).display == 'none') {
        sidebar.style.display = 'block';
        refreshSideBar()
    } else {
        sidebar.style.display = 'none';
    }
}

function refreshSideBar() {
    nodeTitle.value = selectNode.title;
    markdownInput.value = selectNode.content;
    autoResize();
}

function autoResize() {
    // 获取页面高度的 50%
    const pageHeight = window.innerHeight;
    const halfPageHeight = pageHeight * 0.5;

    const newHeight = Math.min(markdownInput.scrollHeight, halfPageHeight);
    markdownInput.style.height = newHeight + 'px';
    
    // 如果内容高度超过最大高度，允许滚动
    if (markdownInput.scrollHeight > halfPageHeight) {
        markdownInput.style.overflow = 'auto';
    } else {
        markdownInput.style.overflow = 'hidden';
    }
}

function save() {
    let title = nodeTitle.value;
    let content = markdownInput.value;
    let id = selectNode.id;
    var dict = {
        "id": id,
        "title": title,
        "content": content
    };
    window.webkit.messageHandlers.editNode.postMessage(dict);
    sidebar.style.display = 'none';
}

function cancel() {
    sidebar.style.display = 'none';
}
