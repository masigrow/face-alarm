#!/usr/bin/env bash
# Face Alarm — GitHub initial setup
# Run once after creating the repo:
#   chmod +x .github/setup.sh && .github/setup.sh
#
# Requires: gh CLI (brew install gh) + gh auth login

set -e

REPO="masigrow/face-alarm"

echo "==> Setting up $REPO"

# ---- Milestones ----
echo "--> Creating milestones..."

gh api repos/$REPO/milestones --method POST \
  -f title="📐 Phase 0 — Spec & Design" \
  -f description="仕様確定・Claude Design モックアップ" \
  -f due_on="2026-07-31T00:00:00Z"

gh api repos/$REPO/milestones --method POST \
  -f title="🔨 Phase 1 — MVP" \
  -f description="コアアラーム + 顔認証解除 (実機動作)" \
  -f due_on="2026-08-31T00:00:00Z"

gh api repos/$REPO/milestones --method POST \
  -f title="🧪 Phase 2 — Beta (TestFlight)" \
  -f description="外部テスター50名・フィードバック反映" \
  -f due_on="2026-09-30T00:00:00Z"

gh api repos/$REPO/milestones --method POST \
  -f title="🚀 Phase 3 — App Store v1.0" \
  -f description="App Store 申請・リリース・PR展開" \
  -f due_on="2026-10-31T00:00:00Z"

# ---- Labels (delete GitHub defaults first, add ours) ----
echo "--> Replacing labels..."

# Remove default labels
for label in "bug" "documentation" "duplicate" "enhancement" "good first issue" \
             "help wanted" "invalid" "question" "wontfix"; do
  gh api repos/$REPO/labels/"$(python3 -c "import urllib.parse; print(urllib.parse.quote('$label'))")" \
    --method DELETE 2>/dev/null || true
done

# Create custom labels
gh api repos/$REPO/labels --method POST -f name="feature"    -f color="0075ca" -f description="New feature or enhancement"
gh api repos/$REPO/labels --method POST -f name="bug"        -f color="d73a4a" -f description="Something isn't working"
gh api repos/$REPO/labels --method POST -f name="design"     -f color="e4e669" -f description="UI/UX — Claude Design task"
gh api repos/$REPO/labels --method POST -f name="marketing"  -f color="f9a828" -f description="Marketing, ASO, social"
gh api repos/$REPO/labels --method POST -f name="chore"      -f color="c5def5" -f description="Dependency, config, CI"
gh api repos/$REPO/labels --method POST -f name="claude-ai"  -f color="7057ff" -f description="Claude Knowledge Plugin / AI integration"

echo ""
echo "✅ Done! Visit: https://github.com/$REPO"
echo "   Milestones: https://github.com/$REPO/milestones"
echo "   Labels:     https://github.com/$REPO/labels"
