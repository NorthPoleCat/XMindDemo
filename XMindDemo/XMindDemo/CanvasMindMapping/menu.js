function showContextMenu(x, y, element) {
    contextMenu.style.left = `${x}px`;
    contextMenu.style.top = `${y}px`;
    contextMenu.style.display = 'block';
    contextMenu.setAttribute('data', element.id)
    contextMenu.setAttribute('parent', element.parent)
}

function hideContextMenu() {
    contextMenu.style.display = 'none';
}

function addOption1() {
    hideContextMenu()
    let id = contextMenu.getAttribute('data')
    window.webkit.messageHandlers.addNode.postMessage(id)
}

function delOption2() {
    hideContextMenu();
    let id = contextMenu.getAttribute('data')
    let parent = contextMenu.getAttribute('parent')
    window.webkit.messageHandlers.delNode.postMessage(id)
}

function detailOption3() {
    hideContextMenu();
    let id = contextMenu.getAttribute('data')
    if (selectNode == null) {
        selectNode = getNode(mindObject.root, id);
        switchSideBar();
    } else if (id == selectNode.id) {
        switchSideBar();
    } else {
        selectNode = getNode(mindObject.root, id);
        sidebar.style.display = 'block';
        refreshSideBar();
    }
}
