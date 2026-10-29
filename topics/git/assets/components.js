/**
 * Git Learning Hub - Modern Interactive Components & Experience Engine
 * Features: Dark/Light Theme Switcher, Reading Progress Bar, Confetti Celebration,
 * Interactive Quiz Engine, Three Trees Pipeline Simulator, Timeline Simulator.
 */

// 1. Theme Management (Dark / Light)
(function initTheme() {
  const savedTheme = localStorage.getItem('git-hub-theme');
  if (savedTheme) {
    document.documentElement.setAttribute('data-theme', savedTheme);
  } else {
    // Default to midnight theme (modern developer dark mode, easy on eyes)
    document.documentElement.setAttribute('data-theme', 'dark');
  }
})();

function toggleTheme() {
  const current = document.documentElement.getAttribute('data-theme');
  const next = current === 'light' ? 'dark' : 'light';
  document.documentElement.setAttribute('data-theme', next);
  localStorage.setItem('git-hub-theme', next);
  updateThemeButton(next);
}

function updateThemeButton(theme) {
  const btn = document.getElementById('themeToggleBtn');
  if (btn) {
    btn.innerHTML = theme === 'light' ? '🌙' : '☀️';
    btn.setAttribute('title', `Switch to ${theme === 'light' ? 'Dark' : 'Light'} Mode`);
  }
}

// 2. Reading Progress Bar & Scroll Listener
window.addEventListener('scroll', () => {
  const progressBar = document.getElementById('topProgressBar');
  if (!progressBar) return;
  const winScroll = document.documentElement.scrollTop || document.body.scrollTop;
  const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
  const scrolled = (winScroll / height) * 100;
  progressBar.style.width = scrolled + '%';
});

// 3. Mini Confetti Particle Effect (Pure JS, Zero External Dependency)
function triggerConfetti() {
  const container = document.createElement('div');
  container.style.position = 'fixed';
  container.style.top = '0';
  container.style.left = '0';
  container.style.width = '100vw';
  container.style.height = '100vh';
  container.style.pointerEvents = 'none';
  container.style.zIndex = '9999';
  document.body.appendChild(container);

  const colors = ['#ff5e36', '#38bdf8', '#10b981', '#f59e0b', '#a855f7'];
  const count = 35;

  for (let i = 0; i < count; i++) {
    const particle = document.createElement('div');
    const color = colors[Math.floor(Math.random() * colors.length)];
    const size = Math.random() * 8 + 6;
    const startX = window.innerWidth / 2 + (Math.random() - 0.5) * 200;
    const startY = window.innerHeight * 0.45;
    
    particle.style.position = 'absolute';
    particle.style.left = startX + 'px';
    particle.style.top = startY + 'px';
    particle.style.width = size + 'px';
    particle.style.height = (size * 0.7) + 'px';
    particle.style.backgroundColor = color;
    particle.style.borderRadius = '2px';
    particle.style.opacity = '1';
    particle.style.transform = `rotate(${Math.random() * 360}deg)`;
    particle.style.transition = 'all 1.2s cubic-bezier(0.25, 1, 0.5, 1)';
    container.appendChild(particle);

    setTimeout(() => {
      const angle = Math.random() * Math.PI * 2;
      const velocity = Math.random() * 260 + 100;
      const endX = startX + Math.cos(angle) * velocity;
      const endY = startY + Math.sin(angle) * velocity + 150;
      particle.style.left = endX + 'px';
      particle.style.top = endY + 'px';
      particle.style.opacity = '0';
      particle.style.transform = `rotate(${Math.random() * 720}deg) scale(0.5)`;
    }, 20);
  }

  setTimeout(() => container.remove(), 1400);
}

// 4. Interactive Quiz Engine
function initQuiz(containerId, options) {
  const container = document.getElementById(containerId);
  if (!container) return;

  const buttons = container.querySelectorAll('.quiz-option');
  const feedback = container.querySelector('.quiz-feedback');
  let answered = false;

  buttons.forEach((btn, index) => {
    btn.addEventListener('click', () => {
      if (answered) return;
      answered = true;

      const isCorrect = index === options.correctIndex;
      if (isCorrect) {
        btn.classList.add('correct');
        btn.innerHTML = `<span style="margin-right: 0.5rem;">✓</span> ${btn.innerHTML}`;
        feedback.className = 'quiz-feedback show correct';
        feedback.innerHTML = `<strong>✨ Spot on!</strong> ${options.explanation}`;
        triggerConfetti();
      } else {
        btn.classList.add('incorrect');
        btn.innerHTML = `<span style="margin-right: 0.5rem;">✕</span> ${btn.innerHTML}`;
        buttons[options.correctIndex].classList.add('correct');
        buttons[options.correctIndex].innerHTML = `<span style="margin-right: 0.5rem;">✓</span> ${buttons[options.correctIndex].innerHTML}`;
        feedback.className = 'quiz-feedback show incorrect';
        feedback.innerHTML = `<strong>💡 Close, but not quite.</strong> ${options.explanation}`;
      }
    });
  });
}

// 5. Interactive Snapshot Simulator (Lesson 0001)
class GitSnapshotSimulator {
  constructor(canvasId, explanationId, steps) {
    this.canvas = document.getElementById(canvasId);
    this.explanation = document.getElementById(explanationId);
    this.steps = steps;
    this.currentStep = 0;
    this.timer = null;
    this.isPlaying = false;
    this.render();
  }

  render() {
    const step = this.steps[this.currentStep];
    if (!step) return;

    if (this.explanation) {
      this.explanation.innerHTML = `<strong>Stage ${this.currentStep + 1} of ${this.steps.length}: ${step.title}</strong><div style="margin-top: 0.5rem; color: var(--text-secondary);">${step.description}</div>`;
    }

    if (this.canvas) {
      this.canvas.innerHTML = step.html;
    }
  }

  next() {
    if (this.currentStep < this.steps.length - 1) {
      this.currentStep++;
      this.render();
    } else {
      this.stop();
    }
  }

  prev() {
    if (this.currentStep > 0) {
      this.currentStep--;
      this.render();
    }
  }

  goTo(stepIndex) {
    if (stepIndex >= 0 && stepIndex < this.steps.length) {
      this.currentStep = stepIndex;
      this.render();
    }
  }

  play() {
    if (this.isPlaying) return;
    this.isPlaying = true;
    if (this.currentStep >= this.steps.length - 1) {
      this.currentStep = 0;
      this.render();
    }
    this.timer = setInterval(() => {
      if (this.currentStep < this.steps.length - 1) {
        this.next();
      } else {
        this.stop();
      }
    }, 3500);
  }

  stop() {
    this.isPlaying = false;
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }
}

// 6. Mini Terminal Simulator
class MiniTerminalSimulator {
  constructor(containerId) {
    this.container = document.getElementById(containerId);
    if (!container) return;
    this.historyEl = this.container.querySelector('.terminal-body');
    this.state = {
      initialized: false,
      staged: false,
      committed: false
    };
  }

  execute(command) {
    if (!this.historyEl) return;
    
    let output = '';
    const cleanCmd = command.trim();

    if (cleanCmd === 'git init') {
      this.state.initialized = true;
      output = 'Initialized empty Git repository in /workspace/my-app/.git/\nCreated hidden .git database to track your snapshots.';
    } else if (cleanCmd === 'git status') {
      if (!this.state.initialized) {
        output = 'fatal: not a git repository (or any of the parent directories): .git';
      } else if (!this.state.staged && !this.state.committed) {
        output = 'On branch main\n\nNo commits yet\n\nUntracked files:\n  (use "git add <file>..." to include in what will be committed)\n\t\x1b[31mapp.js\x1b[0m\n\t\x1b[31mindex.html\x1b[0m\n\nnothing added to commit but untracked files present';
      } else if (this.state.staged && !this.state.committed) {
        output = 'On branch main\n\nNo commits yet\n\nChanges to be committed:\n  (use "git rm --cached <file>..." to unstage)\n\t\x1b[32mnew file:   app.js\x1b[0m\n\t\x1b[32mnew file:   index.html\x1b[0m';
      } else {
        output = 'On branch main\nnothing to commit, working tree clean';
      }
    } else if (cleanCmd === 'git add .') {
      if (!this.state.initialized) {
        output = 'fatal: not a git repository (or any of the parent directories): .git';
      } else {
        this.state.staged = true;
        output = '✓ Added all modified and untracked files into the Staging Area.';
      }
    } else if (cleanCmd.startsWith('git commit')) {
      if (!this.state.initialized) {
        output = 'fatal: not a git repository';
      } else if (!this.state.staged) {
        output = 'On branch main\nUntracked files:\n  app.js\n  index.html\n\nnothing added to commit but untracked files present (use "git add" to stage)';
      } else {
        this.state.committed = true;
        this.state.staged = false;
        output = '[main (root-commit) 9a3e21b] Initial project snapshot\n 2 files changed, 48 insertions(+)\n create mode 100644 app.js\n create mode 100644 index.html\n✓ Immutable snapshot sealed into .git/objects/!';
      }
    } else {
      output = `zsh: command not recognized: ${cleanCmd}`;
    }

    // Format color codes to HTML spans
    const formattedOutput = output
      .replace(/\x1b\[31m/g, '<span style="color: #f43f5e;">')
      .replace(/\x1b\[32m/g, '<span style="color: #10b981;">')
      .replace(/\x1b\[0m/g, '</span>');

    const commandEntry = document.createElement('div');
    commandEntry.style.marginBottom = '1rem';
    commandEntry.innerHTML = `
      <div><span class="terminal-prompt">you@terminal:~/my-app$</span> <span class="terminal-cmd">${cleanCmd}</span></div>
      <div class="terminal-output">${formattedOutput}</div>
    `;
    this.historyEl.appendChild(commandEntry);
    this.historyEl.scrollTop = this.historyEl.scrollHeight;
  }
}

// 7. Three Trees Pipeline Simulator (Lesson 0002)
class ThreeTreesPipelineSimulator {
  constructor(containerId) {
    this.container = document.getElementById(containerId);
    if (!container) return;
    this.wtEl = this.container.querySelector('#wtColumn .tree-body');
    this.saEl = this.container.querySelector('#saColumn .tree-body');
    this.repoEl = this.container.querySelector('#repoColumn .tree-body');
    this.infoEl = this.container.querySelector('#pipelineInfo');

    this.files = {
      'index.html': { status: 'untracked' },
      'styles.css': { status: 'untracked' },
      'app.js': { status: 'untracked' }
    };
    this.stagedFiles = {};
    this.commits = [];
    this.render();
  }

  setInfo(msg) {
    if (this.infoEl) {
      this.infoEl.innerHTML = msg;
    }
  }

  render() {
    // Render Working Tree
    if (this.wtEl) {
      this.wtEl.innerHTML = '';
      const fileNames = Object.keys(this.files);
      if (fileNames.length === 0) {
        this.wtEl.innerHTML = '<div style="color: var(--text-muted); font-size: 0.85rem; font-style: italic; padding: 1rem 0; text-align: center;">Working tree clean.<br>No uncommitted edits.</div>';
      } else {
        fileNames.forEach(name => {
          const file = this.files[name];
          const div = document.createElement('div');
          div.className = `file-item ${file.status}`;
          div.innerHTML = `<span>📄 ${name}</span> <span class="file-status-pill">${file.status}</span>`;
          this.wtEl.appendChild(div);
        });
      }
    }

    // Render Staging Area (Index)
    if (this.saEl) {
      this.saEl.innerHTML = '';
      const stagedNames = Object.keys(this.stagedFiles);
      if (stagedNames.length === 0) {
        this.saEl.innerHTML = '<div style="color: var(--text-muted); font-size: 0.85rem; font-style: italic; padding: 1rem 0; text-align: center;">Staging area empty.<br>Use <code>git add</code> to prepare files.</div>';
      } else {
        stagedNames.forEach(name => {
          const div = document.createElement('div');
          div.className = 'file-item staged';
          div.innerHTML = `<span>✓ ${name}</span> <span class="file-status-pill">staged</span>`;
          this.saEl.appendChild(div);
        });
      }
    }

    // Render Repository (Commits)
    if (this.repoEl) {
      this.repoEl.innerHTML = '';
      if (this.commits.length === 0) {
        this.repoEl.innerHTML = '<div style="color: var(--text-muted); font-size: 0.85rem; font-style: italic; padding: 1rem 0; text-align: center;">No commits yet.<br>Commit staged files to seal history.</div>';
      } else {
        this.commits.forEach(c => {
          const div = document.createElement('div');
          div.className = 'file-item committed';
          div.innerHTML = `<div><strong>#${c.hash}</strong>: ${c.msg}<div style="font-size: 0.75rem; color: var(--text-muted); margin-top: 3px;">Snapshot contains: ${c.files.join(', ')}</div></div>`;
          this.repoEl.appendChild(div);
        });
      }
    }
  }

  editFile(name) {
    this.files[name] = { status: 'modified' };
    this.setInfo(`✏️ Modified <code>${name}</code> in your <strong>Working Tree</strong>. It is now marked in amber as modified, but NOT staged yet!`);
    this.render();
  }

  addFile(name) {
    if (!this.files[name]) {
      this.setInfo(`File <code>${name}</code> is already staged or clean.`);
      return;
    }
    this.stagedFiles[name] = true;
    delete this.files[name];
    this.setInfo(`📥 Ran <code>git add ${name}</code>: Placed <code>${name}</code> into the <strong>Staging Area</strong> (ready for next snapshot).`);
    this.render();
  }

  addAll() {
    const keys = Object.keys(this.files);
    if (keys.length === 0) {
      this.setInfo(`Nothing to add. Working tree is clean.`);
      return;
    }
    keys.forEach(k => {
      this.stagedFiles[k] = true;
    });
    this.files = {};
    this.setInfo(`📥 Ran <code>git add .</code>: All pending files moved into the <strong>Staging Area</strong>.`);
    this.render();
  }

  commit(msg) {
    const stagedNames = Object.keys(this.stagedFiles);
    if (stagedNames.length === 0) {
      this.setInfo(`⚠️ Cannot commit: The Staging Area is empty! Run <code>git add</code> first to stage your changes.`);
      return;
    }
    const hash = Math.random().toString(16).substring(2, 9);
    this.commits.unshift({
      hash: hash,
      msg: msg,
      files: [...stagedNames]
    });
    this.stagedFiles = {};
    this.setInfo(`🎉 Ran <code>git commit -m "${msg}"</code>: Created immutable snapshot <code>${hash}</code> in Git Repository! Staging Area cleared.`);
    triggerConfetti();
    this.render();
  }

  reset() {
    this.files = {
      'index.html': { status: 'untracked' },
      'styles.css': { status: 'untracked' },
      'app.js': { status: 'untracked' }
    };
    this.stagedFiles = {};
    this.commits = [];
    this.setInfo(`🔄 Reset playground state to initial uncommitted files.`);
    this.render();
  }
}

// Initialize theme toggle button if present on page load
document.addEventListener('DOMContentLoaded', () => {
  const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
  updateThemeButton(currentTheme);
});
