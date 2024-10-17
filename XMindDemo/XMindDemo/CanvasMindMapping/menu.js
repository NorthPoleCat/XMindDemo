function showContextMenu(x, y, element) {
    contextMenu.style.left = `${x}px`;
    contextMenu.style.top = `${y}px`;
    contextMenu.style.display = 'block';
    contextMenu.setAttribute('data', element.id)
}

function hideContextMenu() {
    contextMenu.style.display = 'none';
}

function addOption1() {
    hideContextMenu()
    let id = document.getElementById('contextMenu').getAttribute('data')
    window.webkit.messageHandlers.addNode.postMessage(id)
}

function delOption2() {
    hideContextMenu();
    let id = document.getElementById('contextMenu').getAttribute('data')
    window.webkit.messageHandlers.delNode.postMessage(id)
}

function detailOption3() {
    hideContextMenu();
    let id = document.getElementById('contextMenu').getAttribute('data')
    if (selectNode == null || id == selectNode.id) {
        selectNode = getNode(mindObject.root, id);
        switchSideBar();
    } else {
        selectNode = getNode(mindObject.root, id);
        refreshSideBar();
    }
}
