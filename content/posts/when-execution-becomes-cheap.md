+++
# owl-source: pieces/when-execution-becomes-cheap.md
title = "When execution becomes cheap"
date = 2026-10-28
description = "AI has made building cheap. Judgment hasn't become any cheaper, and I'm not sure we're protecting it."
[taxonomies]
tags = ["ai","healthcare","leadership","talks"]
+++


I gave a short talk recently on one idea: AI is making execution cheap. Coding, building, researching, operating. All of it costs a fraction of what it used to. What it hasn't made cheap is judgment.

This is roughly what I said, minus the slides, and a little more honest than I was on stage.

## A mistake I learned early on

Early in my career I believed I was becoming a domain expert. I wasn't.

I'm a technology person. What I'm actually good at is seeing that very different problems often have the same technology underneath. Expertise is something I respect and rely on. What I've done is learn the technology side of each domain really well, and pick up a bit or two about the specialised parts along the way.

Lending taught me this early. Building a loan acquisition journey is, honestly, a fairly simple technology roadmap. Defining the financial product behind that loan is a very, very different kind of work. Automotive was the same story with a different vocabulary.

Healthcare made it impossible to pretend. We have doctors on the team now. They are the fundamentals people, and they guide us. I read a lot about how clinical work happens, but I treat it as outside input, not as something I own.

The hard part is the translation. Turning a doctor's expertise into engineering constructs is very, very difficult. And that translation is human. Handing it to an AI is a big risk.

## How I think about my career now

I don't think of it as a ladder anymore. I think of it in two dimensions: what kind of work I'm doing, and what size of organisation I'm doing it in.

I've moved between very large organisations and small teams, between building platforms for thousands of people and building products with a handful, and between working for someone and thinking about running something of my own. Every switch felt like starting over, and every time the technology fundamentals carried across while the domain did not.

Through all of it, I've been building with AI since 2017, long before anyone called it GenAI.

## Every patient is an edge case

Prototyping is always good. Rolling out, time to market, is better.

Fifty iterations inside the building are worth less than five where you get real feedback, because real data is always fundamentally different.

In most domains we call these edge cases. In healthcare, every patient is an edge case. From the outside, two kids with asthma look the same. The moment you start working on outcomes, every history, every medication list, every chart is different.

## LLMs are great. People still need deterministic software.

AI has added speed. It has also added slop.

An LLM can read a 60-page chart and draft a discharge summary in seconds. Great. It can also confidently carry forward a medication the patient stopped last week. So the medication list isn't the model's call. Rules reconcile it against the EHR.

Same in lending. A model can read payslips and bank statements in seconds. It can also produce a very fluent decline that nobody can explain to a regulator. So the scorecard decides, and every decline carries a reason code.

{% <note header="And yes, cost still matters"> %}
As of last week, throwing a 60-page chart at an LLM for every patient, every time, still costs seconds and real money. A purpose-built inference runs in milliseconds, at scale. We need fast, reliable systems, not just clever ones.
{% </note> %}

## One emergency visit, under the hood

A child comes to the emergency department with an asthma exacerbation. From the outside, the follow-up is one appointment. Under the hood, it's sixteen steps, and the follow-up protocol alone needs about 400 days of the child's chart.

{% <note clickable={true} hidden={true} header="See all sixteen steps"> %}
The discharge note lands in the EHR. It gets parsed, the patient is matched, the encounter is classified, and a follow-up protocol is picked. About 400 days of the chart are pulled and summarised. A risk level and a follow-up window are set, and care gaps are checked. A slot is found, the parent is contacted, and the appointment is booked back into the EHR. A brief is drafted for the clinician, who reviews and signs. Reminders and no-shows are handled, and the outcome is tracked.
{% </note> %}

The model does four of those sixteen steps. Everything else is deterministic software that has to be right for every patient, every time. We've spent about two and a half years building this ourselves: our own agentic framework, our own fine-tuned models, our own protocol engines.

## A prompt slapped on an LLM is not an agent

Neither are fifty conditions wired together in LangChain. That's a flowchart with a model inside.

An agent owns one job. It knows its goal, its tools, its limits, and when to hand over to a person. The limits matter most. On a medication renewal, the agent pulls the history, checks the protocol and drafts the renewal. The clinician signs. The agent never sends a prescription or changes a dose. Not because we asked nicely in a prompt. It just doesn't have that permission.

Autonomy is earned, one step at a time. First the agent prepares and the clinician does. Then the agent completes and the clinician signs. Only with a track record does the clinician move to auditing.

## Fewer people, deeper work

We started with about 25 people and zero agents in production. Today we're almost half the size and run around 25 agents.

I know that sounds like a sad, half-the-people story. It isn't the point. Twenty-five people have 300 lines of communication between them. Twelve have 66. Each of those lines is a place where meaning gets lost. Remove the communication and management barriers, and you just don't need that many people.

So we go deep on focused problems, and instead of hiring more, we pay better. Some of our product folks moved into customer success and FDE roles. That's not support, which most dev orgs treat almost as a taboo. It's owning the outcome at the customer. Everybody wants FDEs and the market doesn't have them, so we grew ours.

## Are we still thinking?

Delivery pressure gets to everyone. In our time the answer was Stack Overflow and burning the midnight oil. Now it's buying a bigger Claude plan.

So: are people actually thinking? Is there intelligence degradation? My answer is yes. The ability to question back is getting weaker.

A few things we're trying. One-year internships instead of six months; riskier, but students actually get to understand the system. Roles by the problem you own, not a title; for lack of a better word, we've cooked up "full-stack AI engineer". And flatter teams, because unnecessary hierarchy creates unnecessary channels, and there's always loss in translation.

And honestly, I'm optimistic about the people coming in. Everyone bashes Gen Z, but Z is the last letter of the alphabet. Maybe they have something to teach us, if we give them accountability, ownership and depth. I got my first smartphone after college; for them it's just natural. My daughter is six, and her questions surprise me every day. The real problem isn't which tools. It's what we teach them, and how.

## Where I've landed

Execution is cheap. Judgment is not. And we might be outsourcing it without noticing.

I'm betting on deterministic software where it matters, small flat teams that own problems, and growing judgment on purpose.

Is there a good answer? I'm not sure. If you've found one, I'd really like to hear it.
