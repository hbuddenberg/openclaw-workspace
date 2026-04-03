#!/bin/bash
# Check GitHub notifications for hbuddenberg (personal repos/orgs only)
# Filter out external/third-party notifications

gh api notifications --paginate=false --jq '.[] | select(.repository.owner.login == "hbuddenberg" or .repository.owner.login == "Arkhur-Vo" or .repository.owner.login == "Kayser-V" or .repository.owner.login == "HansBuddenbergBlamey") | "\(.updated_at[:10]) \(.subject.type) \(.subject.title) — \(.repository.full_name) (\(.reason))"' 2>&1
