# Agent-Trainer - Design Document

**Date**: 2026-10-03
**Status**: Design

## Overview
An OpenCode agent that helps users optimize fitness, workouts, and general training by:
- Analyzing workout history from Hevy
- Providing personalized recommendations based on user profile
- Setting and tracking measurable goals
- suggesting progressive overload and recovery strategies

## User Requirements

### Data Access
- **Primary**: Hevy mcp with user-provided API key
- **Fallback**: CSV export via browser-mcp when no API key available

### User Profile (`data/user.md`)
Agent collects on first interaction:
- Personal info: name, age, gender, weight (lb), height (ft-in)
- Physical background: experience level, previous sports, fitness level
- Health: injuries, medical conditions, mobility limitations
- Schedule: available days, session duration
- Facility: equipment access

### Goals (`data/goals.md`)
- General training goal
- Measurable monthly goals with targets and deadlines
- Progress tracking with motivation

### Training Intelligence
- Progressive overload suggestions
- Periodization planning
- Exercise recommendations based on goals, workout history, and mucle groups
- Recovery recommendations based on days since last workout
- Date-aware session planning

### Constraints
- Read-only access to Hevy data (never modify workouts)
- Full conversation logging in `data/conversations.md`

---

## Project Structure

```
agent-trainer/
|-- .env                        # HEVY_API_KEY
|-- .gitignore
|-- opencode.json
|-- start.sh                    # Launch script
|-- .opencode/
|   |-- agents/
|   |   |-- agent-trainer.md    # Primary agent definition
|   |-- skills/
|       |--hevy-export/
|           |-- SKILL.md
|           |-- scripts/
|               |-- parse-csv.py
|-- data/                       # User data (gitignored)
|   |-- .gitkeep
|-- docs/
    |-- plans/
        |-- 2026-10-03-agent-trainer-design.md
```

## Agent Behavior Flow

SESSION START
0. Check .env for HEVY_API_KEY
- Missing -> ask user for key or offer CSV fallback
- Present -> Continue
1. Check data/user.md
- Missing -> Collect full profile
            Save to data/user.md
- Present -> Load profile
2. Check data/goals.md
- Missing -> Suggest goals bsed on profile
            Help set measurable monthly targets
            Save to data/goals.md
- Present -> Load goals
3. Regular Session
    a. Run `date` for current date context
    b. Fetch recent workouts from Hevy
    c. Calculate days since last workout
    d. Compare performance to goals
    e. Recommend rest or next workout
    f. Log conversation to data/conversation.md


