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
