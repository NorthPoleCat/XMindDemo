let isDragging = false;
let prevLine = null;
let startNode = null;
let endNode = null;

let startX = 0;
let startY = 0;
let lastX = 0;
let lastY = 0;

let crossingNodes = [];

function clearPreviousLine() {
    if (prevLine) {
        const { x1, y1, x2, y2 } = prevLine;
        ctx.clearRect(x1 - 1, y1 - 1, x2 - x1 + 2, y2 - y1 + 2);
        drawCrossingNode(); // 重绘其他元素
    }
}

function drawLine(x1, y1, x2, y2) {
    clearPreviousLine();
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.strokeStyle = 'black';
    ctx.lineWidth = 2;
    ctx.stroke();

    // 保存当前线条的位置，用于下次清除
    prevLine = { x1, y1, x2, y2 };
}

canvas.addEventListener('mousedown', function(event) {
    hideContextMenu()
    elementslist.forEach(element => {
        if (ctx.isPointInPath(element[0], event.offsetX*PIXEL_RATIO, event.offsetY*PIXEL_RATIO)) {
            const rect = canvas.getBoundingClientRect();
            startX = e.clientX - rect.left;
            startY = e.clientY - rect.top;
            isDragging = true;
            prevLine = null;
        }
    })
});

canvas.addEventListener('mousemove', (e) => {
    if (isDragging) {
        const rect = canvas.getBoundingClientRect();
        lastX = e.clientX - rect.left;
        lastY = e.clientY - rect.top;

        drawLine(startX, startY, lastX, lastY); // 每次移动时只画最新的线条
    }
});

canvas.addEventListener('mouseup', () => {
    isDragging = false;

    // 绘制最终线条，不再清除
    ctx.beginPath();
    ctx.moveTo(startX, startY);
    ctx.lineTo(lastX, lastY);
    ctx.strokeStyle = 'black';
    ctx.lineWidth = 2;
    ctx.stroke();

    prevLine = null; // 完成后重置
});

function drawCrossingNode() {
    
}

