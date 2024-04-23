// CreateCheckRun creates a new check run.
func CreateCheckRun(owner, repo, name, headSHA string) (*github.CheckRun, error) {
    options := &github.CreateCheckRunOptions{
        Name:    name,
        HeadSHA: headSHA,
        Status:  github.String("queued"), // initially set to 'queued'
        StartedAt: &github.Timestamp{Time: time.Now()},
    }
    checkRun, _, err := authenticateClient.Checks.CreateCheckRun(CTX, owner, repo, *options)
    return checkRun, err
}

// StartCheckRun marks a check run as in progress.
func StartCheckRun(owner, repo string, checkRunID int64) (*github.CheckRun, error) {
    options := &github.UpdateCheckRunOptions{
        Status:     github.String("in_progress"),
        StartedAt:  &github.Timestamp{Time: time.Now()},
    }
    checkRun, _, err := authenticateClient.Checks.UpdateCheckRun(CTX, owner, repo, checkRunID, *options)
    return checkRun, err
}

// UpdateCheckRun updates an existing check run with dynamic information.
func UpdateCheckRun(owner, repo string, checkRunID int64, status string, title, summary, text string, conclusion *string) (*github.CheckRun, error) {
    updateOptions := &github.UpdateCheckRunOptions{
        Status: github.String(status),
        Output: &github.CheckRunOutput{
            Title:   github.String(title),
            Summary: github.String(summary),
            Text:    github.String(text),
        },
    }

    // If the check run is completed, we need to set the conclusion and the completion timestamp
    if status == "completed" && conclusion != nil {
        updateOptions.Conclusion = conclusion
        updateOptions.CompletedAt = &github.Timestamp{Time: time.Now()}
    }

    checkRun, _, err := authenticateClient.Checks.UpdateCheckRun(CTX, owner, repo, checkRunID, *updateOptions)
    return checkRun, err
}


// CompleteCheckRun marks a check run as completed with a given conclusion.
func CompleteCheckRun(owner, repo string, checkRunID int64, conclusion string) (*github.CheckRun, error) {
    options := &github.UpdateCheckRunOptions{
        Status:     github.String("completed"),
        Conclusion: github.String(conclusion),
        CompletedAt: &github.Timestamp{Time: time.Now()},
    }
    checkRun, _, err := authenticateClient.Checks.UpdateCheckRun(CTX, owner, repo, checkRunID, *options)
    return checkRun, err
}
