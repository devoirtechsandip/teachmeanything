# The Time Machine: Modern Restores, Reverts, and Reset Mechanics Established

Learner advanced through Module 5: The Time Machine & Undoing Mistakes. Clarified the crucial boundary between uncommitted work (`git restore` / `git restore --staged`) and committed history manipulation, establishing the strict rule: `git revert` for shared public history, and `git reset` (--soft, --mixed, --hard) strictly for unpushed local branches.

## Evidence
- Interactive restore simulator testing `--staged` secret prevention vs working tree discard.
- Revert vs soft/mixed/hard reset state inspector simulation verified.
- Reference cards #09 and #10 published.

## Implications
Unlocks Module 6: Clean History & Advanced Rebasing. The learner can recover from mistakes with confidence and is ready to learn how to rewrite local commits for clean Pull Requests.
