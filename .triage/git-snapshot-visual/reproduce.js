const fs = require('fs');
const path = require('path');
const vm = require('vm');

// Mock a lightweight browser window/document environment
class ElementMock {
  constructor(id, tagName = 'div') {
    this.id = id;
    this.tagName = tagName;
    this.innerHTML = '';
    this.children = [];
    this.style = {};
    this.classList = {
      add: () => {},
      remove: () => {}
    };
  }

  querySelector(selector) {
    if (selector === '.terminal-body') return new ElementMock('terminal-body');
    if (selector === '#pipelineInfo') return new ElementMock('pipelineInfo');
    if (selector.includes('.tree-body')) return new ElementMock('tree-body');
    return new ElementMock('sub-el');
  }

  querySelectorAll(selector) {
    return [new ElementMock('opt1'), new ElementMock('opt2')];
  }

  appendChild(el) {
    this.children.push(el);
  }

  addEventListener() {}
}

const elements = {
  themeToggleBtn: new ElementMock('themeToggleBtn'),
  topProgressBar: new ElementMock('topProgressBar'),
  terminalDemo: new ElementMock('terminalDemo'),
  quiz1: new ElementMock('quiz1'),
  quiz2: new ElementMock('quiz2'),
  animCanvas: new ElementMock('animCanvas'),
  animExplanation: new ElementMock('animExplanation'),
  prevBtn: new ElementMock('prevBtn'),
  playBtn: new ElementMock('playBtn'),
  nextBtn: new ElementMock('nextBtn'),
  resetBtn: new ElementMock('resetBtn')
};

const domMock = {
  documentElement: {
    setAttribute: () => {},
    getAttribute: () => 'dark'
  },
  getElementById: (id) => elements[id] || null,
  createElement: (tag) => new ElementMock('created', tag),
  addEventListener: () => {},
  body: new ElementMock('body')
};

const sandbox = {
  window: {
    addEventListener: () => {}
  },
  document: domMock,
  localStorage: {
    getItem: () => null,
    setItem: () => {}
  },
  console: console,
  setInterval: () => 1,
  clearInterval: () => {},
  setTimeout: () => 1,
  alert: () => {}
};
sandbox.window.document = domMock;

vm.createContext(sandbox);

const componentsJs = fs.readFileSync(
  path.join(__dirname, '../../topics/git/assets/components.js'),
  'utf8'
);

const lessonHtml = fs.readFileSync(
  path.join(__dirname, '../../topics/git/lessons/0001-why-git-and-the-snapshot-model.html'),
  'utf8'
);

// Extract the inline script from lesson 0001
const scriptMatch = lessonHtml.match(/<script>([\s\S]*?)<\/script>/);
if (!scriptMatch) {
  console.error("No inline script found in lesson HTML!");
  process.exit(1);
}
const inlineScript = scriptMatch[1];

try {
  // Execute components.js first
  vm.runInContext(componentsJs, sandbox);

  // Execute inline script
  vm.runInContext(inlineScript, sandbox);

  // Check if animCanvas was populated
  const canvasContent = elements.animCanvas.innerHTML;
  if (!canvasContent || canvasContent.trim() === '') {
    console.error("FAIL: animCanvas is empty! Visuals not rendered.");
    process.exit(1);
  }

  console.log("SUCCESS: animCanvas is populated with:", canvasContent.substring(0, 80));
  process.exit(0);
} catch (err) {
  console.error("REPRODUCTION ERROR CAUGHT:", err.message);
  console.error("FAIL: Script crashed before rendering animCanvas!");
  process.exit(1);
}
