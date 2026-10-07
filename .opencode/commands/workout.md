---
description: Recommend a 5-7 exercise workout for a focus area (e.g. /workout chest, /workout legs)
agent: agent-trainer
---

Recommend a single workout for today, focused on: $ARGUMENTS

If the focus above is empty, do not guess. Look at recent training and recovery, suggest which area is most due, and ask the user to confirm before building the workout.

# Gather context first
Skip anything you already loaded this session; otherwise do it now:
1. Read `data/user.md` (equipment, injuries and limitations, session length, experience) and `data/goals.md`.
2. Run `date`.
3. Fetch recent workouts from Hevy, and the exercise library as needed.

# Check recovery before building
- If the focus muscle group was trained hard in the last 48 hours, say so with the specifics (what and when). Recommend either a different focus or a lighter session for that area, and let the user choose before you build anything.
- If the user has trained many days in a row, say so and consider recommending rest.

# Build the workout
- **Exercise count**: 5 to 7 exercises total.
- **Focus**: Most of the workout targets the focus area. Fill the rest with supporting or complementary movements so several areas of the body are covered (for example, a leg-focused day can include an upper-body pull; a chest day can include back or shoulders).
- **Compound movements**: Include several compound, multi-joint movements, especially for the focus area, and put them first, while the user is fresh. Isolation work comes after.
- **Core**: Include exactly one abdominal exercise, placed last. Skip it only if an injury or limitation in `data/user.md` makes it unwise, and say why.
- **Equipment and limits**: Use only equipment the user has access to. Avoid or modify anything that conflicts with their injuries or limitations.
- **Hevy exercises**: Choose exercises that exist in the user's Hevy exercise library and use the exact Hevy names so the user can find and log them. Prefer exercises they have done before, so you can base weights on real history. A new exercise is fine, but flag it as new.
- **Goals and variety**: Tie the selection to their current goals. Don't repeat the exact same workout as their most recent session for this focus; vary exercises or rep ranges sensibly while keeping progressions going.
- **Length**: Keep the total work realistic for their session duration.
- **Order**: Order exercises such that each set of 2 can be performed in a superset.

# Prescribe the work
For each exercise give sets x reps and a target weight (in lb) based on their history and the progressive overload rules: nudge up if they hit their targets last time, hold or reduce if they missed. For a new exercise with no history, recommend a conservative starting weight and say to adjust by feel. Include rest time for the compound lifts.

# Output format
Start with one or two sentences explaining why this workout fits today (focus, recovery, goals). Then give the numbered list:

1. **Exercise name** - sets x reps @ weight lb, rest. Short note only if needed (form cue, substitution, new exercise).

End by offering to swap exercises or adjust the length. Do not create or modify anything in Hevy; the user logs the workout themselves.

Do not write to `data/conversation.md` unless the user accepts or changes the plan in a way that is a durable decision.
