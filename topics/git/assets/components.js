/**
 * Git Learning Hub - Reusable Interactive Components
 * Provides: Quiz Engine, Interactive Visual Timeline/Snapshot Animation, Terminal Mock Simulator.
 */

// 1. Reusable Quiz Engine
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
        feedback.className = 'quiz-feedback show correct';
        feedback.innerHTML = `<strong>Correct!</strong> ${options.explanation}`;
      } else {
        btn.classList.add('incorrect');
        buttons[options.correctIndex].classList.add('correct');
        feedback.className = 'quiz-feedback show incorrect';
        feedback.innerHTML = `<strong>Not quite.</strong> ${options.explanation}`;
      }
    });
  });
}

// 2. Interactive Snapshot & Timeline Animator
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
      this.explanation.innerHTML = `<strong>Step ${this.currentStep + 1} of ${this.steps.length}: ${step.title}</strong><p style="margin-top: 0.4rem; margin-bottom: 0;">${step.description}</p>`;
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
    }, 3200);
  }

  stop() {
    this.isPlaying = false;
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }
}

// 3. Mini Interactive Terminal Simulator
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
      output = 'Initialized empty Git repository in /workspace/my-app/.git/\nCreated .git folder to track your project history.';
    } else if (cleanCmd === 'git status') {
      if (!this.state.initialized) {
        output = 'fatal: not a git repository (or any of the parent directories): .git';
      } else if (!this.state.staged && !this.state.committed) {
        output = 'On branch main\n\nNo commits yet\n\nUntracked files:\n  (use "git add <file>..." to include in what will be committed)\n\tapp.js\n\tindex.html\n\nnothing added to commit but untracked files present';
      } else if (this.state.staged && !this.state.committed) {
        output = 'On branch main\n\nNo commits yet\n\nChanges to be committed:\n  (use "git rm --cached <file>..." to unstage)\n\tnew file:   app.js\n\tnew file:   index.html';
      } else {
        output = 'On branch main\nnothing to commit, working tree clean';
      }
    } else if (cleanCmd === 'git add .') {
      if (!this.state.initialized) {
        output = 'fatal: not a git repository (or any of the parent directories): .git';
      } else {
        this.state.staged = true;
        output = '✓ Added all modified and new files to the Staging Area (ready for snapshot).';
      }
    } else if (cleanCmd.startsWith('git commit')) {
      if (!this.state.initialized) {
        output = 'fatal: not a git repository';
      } else if (!this.state.staged) {
        output = 'On branch main\nUntracked files:\n  app.js\n  index.html\n\nnothing added to commit but untracked files present (use "git add" to stage)';
      } else {
        this.state.committed = true;
        this.state.staged = false;
        output = '[main (root-commit) 9a3e21b] Initial project snapshot\n 2 files changed, 48 insertions(+)\n create mode 100644 app.js\n create mode 100644 index.html\n✓ Immutable snapshot created and saved to .git database!';
      }
    } else {
      output = `zsh: command not recognized: ${cleanCmd}`;
    }

    const commandEntry = document.createElement('div');
    commandEntry.innerHTML = `
      <div><span class="terminal-prompt">you@terminal:~/my-app$</span> <span class="terminal-cmd">${cleanCmd}</span></div>
      <div class="terminal-output">${output}</div>
    `;
    this.historyEl.appendChild(commandEntry);
    this.historyEl.scrollTop = this.historyEl.scrollHeight;
  }
}

// 4. Three Trees Pipeline Simulator (Working Tree -> Staging Area -> Repository)
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
        this.wtEl.innerHTML = '<div style="color: var(--text-muted); font-size: 0.85rem; font-style: italic;">Working tree clean (no uncommitted edits).</div>';
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
        this.saEl.innerHTML = '<div style="color: var(--text-muted); font-size: 0.85rem; font-style: italic;">Staging area empty. Use <code>git add</code> to prepare files.</div>';
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
        this.repoEl.innerHTML = '<div style="color: var(--text-muted); font-size: 0.85rem; font-style: italic;">No commits yet. Commit staged changes to form history.</div>';
      } else {
        this.commits.forEach(c => {
          const div = document.createElement('div');
          div.className = 'file-item committed';
          div.innerHTML = `<div><strong>${c.hash}</strong>: ${c.msg}<div style="font-size: 0.72rem; color: var(--text-muted); margin-top: 2px;">files: ${c.files.join(', ')}</div></div>`;
          this.repoEl.appendChild(div);
        });
      }
    }
  }

  editFile(name) {
    this.files[name] = { status: 'modified' };
    this.setInfo(`✏️ Modified <code>${name}</code> in the Working Tree. Notice it is flagged in yellow as <strong>modified</strong>, but NOT staged yet!`);
    this.render();
  }

  addFile(name) {
    if (!this.files[name]) {
      this.setInfo(`File <code>${name}</code> is not modified.`);
      return;
    }
    this.stagedFiles[name] = true;
    delete this.files[name];
    this.setInfo(`📥 Ran <code>git add ${name}</code>: <code>${name}</code> moved into the <strong>Staging Area</strong> (ready for next snapshot).`);
    this.render();
  }

  addAll() {
    const keys = Object.keys(this.files);
    if (keys.length === 0) {
      this.setInfo(`Nothing to add. Working tree has no un-staged modifications.`);
      return;
    }
    keys.forEach(k => {
      this.stagedFiles[k] = true;
    });
    this.files = {};
    this.setInfo(`📥 Ran <code>git add .</code>: All uncommitted files moved into the <strong>Staging Area</strong>.`);
    this.render();
  }

  commit(msg) {
    const stagedNames = Object.keys(this.stagedFiles);
    if (stagedNames.length === 0) {
      this.setInfo(`⚠️ Cannot commit: Staging area is completely empty! Run <code>git add</code> first.`);
      return;
    }
    const hash = Math.random().toString(16).substring(2, 9);
    this.commits.unshift({
      hash: hash,
      msg: msg,
      files: [...stagedNames]
    });
    this.stagedFiles = {};
    this.setInfo(`📸 Ran <code>git commit -m "${msg}"</code>: Created permanent snapshot <code>${hash}</code> in Git Repository! Staging area cleared.`);
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

