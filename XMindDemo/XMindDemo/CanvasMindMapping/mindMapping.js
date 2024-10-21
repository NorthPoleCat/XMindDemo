//let canvas = document.getElementById('canvas');
//let ctx = canvas.getContext('2d');

var PIXEL_RATIO = (function () {
    var ctx = document.createElement("canvas").getContext("2d"),
        dpr = window.devicePixelRatio || 1,
        bsr = ctx.webkitBackingStorePixelRatio ||
              ctx.mozBackingStorePixelRatio ||
              ctx.msBackingStorePixelRatio ||
              ctx.oBackingStorePixelRatio ||
              ctx.backingStorePixelRatio || 1;
    return dpr / bsr;
})();


createHiDPICanvas = function(w, h, ratio) {
    if (!ratio) { ratio = PIXEL_RATIO; }
    var can = document.createElement("canvas");
    can.width = w * ratio;
    can.height = h * ratio;
    can.style.width = w + "px";
    can.style.height = h + "px";
    can.getContext("2d").setTransform(ratio, 0, 0, ratio, 0, 0);
    return can;
}

resetHiDPICanvas = function(w, h, ratio) {
    if (!ratio) { ratio = PIXEL_RATIO; }
    var can = document.getElementsByTagName("canvas")[0];
    can.width = w * ratio;
    can.height = h * ratio;
    can.style.width = w + "px";
    can.style.height = h + "px";
    can.getContext("2d").setTransform(ratio, 0, 0, ratio, 0, 0);
    return can;
}

let canvas = createHiDPICanvas(100, 100);
let ctx = canvas.getContext('2d');
setFontSize(18);
//ctx.font = '30px Helvetica';

const body = document.getElementsByTagName("div")[0];
body.appendChild(canvas);

let nodeMargin = 10;
let columnPadding = 30;

let radius = 3;
let heightGap = 30;
let nodeWidth = 150;

//render elements
var elementslist = [];

//data model
var nodes = [];

let saveTimeout;

//node positions
var positions = [];

//指向当前render node的maxY + gap, 即下一个同级节点（如果存在）的minY
var currentChildPos = 0;

var parentChildrenHeightWithinLines = 0;

var canvasH = 0;
var canvasW = 0;

window.onload = function() {
    //每次加载调用
    window.webkit.messageHandlers.load.postMessage('');
}

function loadData(mind) {
    const jsonString = unescape(mind);
    mindObject = JSON.parse(jsonString);
    childrenHeight(mindObject.root);
    getNodesPosition(mindObject.root);
    renderNodes(positions);
    setLine();
}

function getNodesPosition(node, parentNode = null, parentPos = null, isRoot = true) {

    if (isRoot) {
        positions = [];
        let nodeY = 0;
        canvasH = node.height + 400;
        canvasW = node.width;
        
        if (node.children.length > 0) {
            nodeY = 200 + Math.max(node.childrenHeight, node.height)*0.5
            if (node.childrenHeight >= node.height) {
                canvasH = node.childrenHeight + 400;
            }
        } else {
            nodeY = 200;
        }
        
        let pos = {
            id: node.id,
            x: 200,
            y: nodeY,
            height: node.height,
            width: node.width,
            lines: node.lines,
            lineHeight: node.lineHeight,
            outline: node.title,
            detail: node.content,
            content: node.title.length > 0 ? node.title : node.content
        };

        positions.push(pos);
        nodes.push(node);

        node.children.sort((a, b) => a.id - b.id); //将children按时间戳排序
        node.children.forEach((key, value) => {
            getNodesPosition(key, node, pos, false);
        });
    } else {

        let nodeY = 0;//指向当前渲染节点的minY
        if (currentChildPos == 0) {
            let parentPosCenterY = parentPos.y + parentPos.height*0.5;
            if (parentNode.children.length > 1) {
                parentChildrenHeightWithinLines = parentNode.childrenHeight-maxNodeHight(parentNode.children[0])*0.5-maxNodeHight(parentNode.children[parentNode.children.length-1])*0.5
                nodeY = parentPosCenterY - parentChildrenHeightWithinLines*0.5 - node.height*0.5;
            } else {
                nodeY = parentPosCenterY - node.height*0.5;
            }
        } else {
            if (node.childrenHeight > node.height) {
                nodeY = currentChildPos + node.childrenHeight*0.5 - node.height*0.5;
            } else {
                nodeY = currentChildPos;
            }
        }
        
        if (node.childrenHeight > node.height) {
            currentChildPos = nodeY + node.height*0.5 + node.childrenHeight*0.5 + heightGap;
        } else {
            currentChildPos = nodeY + node.height + heightGap;
        }

        let pos = {
            id: node.id,
            x: parentPos.x + parentPos.width + columnPadding,
            y: nodeY,
            height: node.height,
            width: node.width,
            lines: node.lines,
            lineHeight: node.lineHeight,
            outline: node.title,
            detail: node.content,
            content: node.title.length > 0 ? node.title : node.content
        };

        positions.push(pos);
        nodes.push(node);
        
        canvasW = Math.max(canvasW, pos.x + node.width);

        if (currentChildPos >= (parentPos.y + parentPos.height*0.5 + parentChildrenHeightWithinLines*0.5)) {
            parentNode.children.forEach((key, value) => {
                currentChildPos = 0;
                parentChildrenHeightWithinLines = 0;
                let subParentPos = getPosById(key.id);
                key.children.forEach((subKey, value) => {
                    getNodesPosition(subKey, key, subParentPos, false);
                });
            })
        }
    }
    
    let canvasSize = Math.max(canvasH + 400, canvasW + 400);
    resetHiDPICanvas(canvasSize, canvasSize);

    return positions;
}

function renderNodes(positions) {

    // var elementslist = [];

    positions.forEach(position => {
        var node = getNodeById(position.id)
        const e = new Path2D();

        e.roundRect(position.x, position.y, position.width, position.height, radius);
        ctx.strokeStyle = 'green';
        ctx.stroke(e);
        setFontSize(18);
        let lines = position.lines
        let lineHeight = position.lineHeight
        for (var i = 0; i < lines.length; i++) {
            //参数y标注的是文字的底部位置
            ctx.fillText(lines[i], position.x + nodeMargin * 0.5, position.y + (i+1) * lineHeight)
        }
        elementslist.push([e, node]);
    });

    canvas.addEventListener('click', function(event) {
        hideContextMenu()
        elementslist.forEach(element => {
            if (ctx.isPointInPath(element[0], event.offsetX*PIXEL_RATIO, event.offsetY*PIXEL_RATIO)) {
                alert('node click placeholder：\n更过功能请右键单击节点')
            }
        })
    });
    
    canvas.addEventListener('contextmenu', function(event) {
        event.preventDefault();//屏蔽默认的‘重新载入’选项
        elementslist.forEach(element => {
            if (ctx.isPointInPath(element[0], event.offsetX*PIXEL_RATIO, event.offsetY*PIXEL_RATIO)) {
                showContextMenu(event.clientX, event.clientY, element[1]);
            }
        })
    });
}

function setLine() {
    positions.forEach(pos => {
        let node  = getNodeById(pos.id);
        if (node.children != null && node.children.length > 0) {
            setLineWith(pos, node, 15);
        }
    });
}

//node为起始节点
//length为第二段折线长度
//height为中间竖线长度
function setLineWith(pos, node, length) {
    //this code is for fixed node width 150
    let beginX = pos.x + pos.width;
    let beginY = pos.y + pos.height * 0.5;
    
    let cornerRadius = 5;
    let firstLength = 10;
    
    let childrenPos = [];
    node.children.forEach((key, value) => {
        childrenPos.push(getPosById(key.id));
    });
    let minChildY = Math.min.apply(Math, childrenPos.map(item => {return item.y + item.height * 0.5}));
    let maxChildY = Math.max.apply(Math, childrenPos.map(item => {return item.y + item.height * 0.5}));

    ctx.beginPath();
    ctx.lineWidth = 2;
    ctx.moveTo(beginX, beginY);
    ctx.lineTo(beginX + firstLength, beginY);
    ctx.lineTo(beginX + firstLength, minChildY);
    ctx.moveTo(beginX + firstLength, beginY);
    ctx.lineTo(beginX + firstLength, maxChildY);

    ctx.strokeStyle = 'black';
    ctx.stroke();
    
    
    childrenPos.forEach(item => {
        ctx.beginPath();
        ctx.moveTo(beginX + firstLength, item.y + item.height * 0.5)
        ctx.lineTo(beginX + columnPadding, item.y + item.height * 0.5);
        ctx.lineWidth = 2;

        // line color
        ctx.strokeStyle = 'black';
        ctx.stroke();
    })
}

//计算单个节点的长宽
function calculateNode(node) {
    // 据说字母M的宽高相等，也可以用来计算高度，但没有尝试
    // let metrics = ctx.measureText(node.content);
    // let fontHeight = metrics.fontBoundingBoxAscent + metrics.fontBoundingBoxDescent;
    // let actualHeight = metrics.actualBoundingBoxAscent + metrics.actualBoundingBoxDescent;
    
    let content = node.title
    
    var row = [];
    var fontHeight = 0;
    var lineHeight = 0;
    var nWidth = nodeWidth;
    
    var chr = content.split("");
    var temp = "";

    for (var a = 0; a < chr.length; a++) {
        temp += chr[a];
        let metrics = ctx.measureText(temp)
        fontHeight = metrics.fontBoundingBoxAscent + metrics.fontBoundingBoxDescent;
        lineHeight = metrics.actualBoundingBoxAscent + metrics.actualBoundingBoxDescent;
        if (metrics.width >= nodeWidth) {
            row.push(temp);
            nWidth = metrics.width > nWidth ? metrics.width : nWidth;
            temp = "";
        }
    }
    row.push(temp);

    return {
        height: row.length * lineHeight*1.5 + nodeMargin,
        width: nWidth + nodeMargin,
        lines: row,
        lineHeight: lineHeight*1.5
    };
}

//在没有子节点时，此函数返回的是node本身的高度
//在有子节点时，此函数返回的是此node所有子节点的总高度
function childrenHeight(node) {
    let cH = 0;
    if (node.children == null || node.children.length == 0) {
        node.childrenHeight = 0;
        let metrics = calculateNode(node);
        node.height = metrics.height;
        node.width = metrics.width;
        node.lines = metrics.lines;
        node.lineHeight = metrics.lineHeight;
        return node.height;
    } else {
        node.children.forEach((key, value) => {
            cH = cH + childrenHeight(key);
        });
        node.childrenHeight = cH + heightGap * (node.children.length - 1);
        let metrics = calculateNode(node);
        node.height = metrics.height;
        node.width = metrics.width;
        node.lines = metrics.lines;
        node.lineHeight = metrics.lineHeight;
        return Math.max(node.childrenHeight, node.height);
    }
}

function getNodeById(identity) {
    return nodes.filter(function(e) {
        return e.id == identity;
    })[0];
}

function getPosById(identity) {
    return positions.filter(function(e) {
        return e.id == identity;
    })[0];
}

// 仅设置字体大小，不改变字体族
function setFontSize(size) {
    const currentFont = ctx.font;
    const fontSize = size + 'px';
    const fontFamily = currentFont.split(' ').slice(1).join(' ');
    ctx.font = fontSize + ' ' + fontFamily;
}

function maxNodeHight(node) {
    return Math.max(node.height, node.childrenHeight);
}
















