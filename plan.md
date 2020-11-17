# Plan of slides

## Introduction

### Scenario

Let us consider our current pandemic **scenario**:

We are all in one room, inter-facing a computer which is recording us.
Currently the **microphones** of this device are hopefully capturing my speech.

Let us ignore the processing that the software is performing.
In particular, they are recording

- the sound of my voice,
- some source of noise, such as the computer fan, transmission noise, the traffic outside, someone of my family in the other rooms, music that my brother is playing, the mobile phone, etc.

These are sound **sources**.
However, if you think about it, there is much more.
From the only audio, you may understand that:

- I am speaking close to the microphones, somehow in foreground with respect to the rest.
- The interfering sound source is far away and probably moving.
- We can understand if we are in a indoor or outdoor environment.

The microphones recording keep tracks of the environment where the sound are being recorded.

In natural environment, the sound propagates and interact with the environment.
The overall effect is well known and it called *reverberation*.
All these makes the audio scene we are immersed into and we assumed it is recorded by microphones.

### Audio Scene Analysis

The ensemble of techniques and methods, which involves math and computer science, aiming at extracting
high level information from raw audio recordings is here denoted as *Audio Scene Analysis*.

Depending on the kind of information we are interested to we can then define some *problems*:

- if we are interested in determining the nature of the sound sources, then we can have audio source classification
- if we are interested in the signal of the sound source, then we speak about audio source separation
- SSL
- diarization
- acoustic measurements and blind channel identification

We can see that this problems corresponds to typical question that we ask ourself:

- What, Where, When, How
- link to ASA/CASA

We should here also notice that everything is connected.
The resolution of one of the above problem may be better if prior information is available.

- Problems can be Blind or Informed
- Problems can be Forward or Inverse

### Signal Processing

It is the role of mathematics and computer science
Signal processing offer us mathematical models, frameworks and models for this.
Typically the signal processing techniques can be grouped in the following blocks.
Let me explain it with a typical example

- representation
- parameter estimation
- enhancement
- adaptive processing

Pipeline picture such as in Robin.

### Echo aware approach

Audio Scene Analysis give us our problems we want to solve
Signal processing give us the tools and the models
Echoes give us useful information that can be used for better processing.

Acoustic echoes are elements of Sound Propagation. therefore they knowledge can be used to better inform inverse problems.
Their information gives an idea of the mixing filters.

Moreover we can also interpret them:

- As sound repetition: echoes brings sound information (example of beamforming??)
- As sound spatialization: they time of arrival (and direction of arrival) depends on the room geometry (example of rooge)

### Challenges and Objective

Current challenges:

- Turning enemies into friends
  - Anechoic (neglecting echoes) -> echoes are enemy
  - Reverberation (modeling the full RIRs) -> very challenging task
- estimating acoustic echoes in noisy environment is a non-trivial task
- how to use properly the information?

In this thesis we will see how to estimate the echoes and how to estimate them and how to integrate this

- model echoes in signal processing
- estimate echoes
- apply echoes
- data for validation

### Outline 1D

In particular, at first I am going to present a model for the echoes under the typical perspective of signal processing.
Then how to estimated with 2 methods, one knowledge based and one learning based.
Then, assuming the echoes are known, we presents a few application.

During the 3 year my investigation were not linear and personally I jumped between application and estimation through out different projects.
Therefore, I may be better to present the outline of the presentation in 2D, in order to highly some dependencies.

## Modeling

*Transition: How do we model the echoes and a sound effected by echoes?*

### Room Acoustics

Sound propagates in the space and it interact with it.
In particular, it takes time to travel and reach the microphones while being attenuated.
It is absorbed with surfaced, difracted around objects, etc.

If we record an impulsive sounds, we will notice the following elements:

- a direct path which accounts for the time the sound takes to travel from the source position to the microphones position
- a few distinct early reflection which can be modeled with the specular low
- reverberation due to the continuous bouncing of reflection

### Signal Processing

In light of the signal processing theory, this process can be modeled with the typical source-filter-receiver model, where the relation between input and output is express with the following convolution.

$$ x_{ij} = (h_{ij} \ast s_j)(t) $$

In other words, microphone $i$ listens to the convolution between the signal of source $j$ and a filter which, in case of room acoustics, accounts for the full propagation of the sound in the room.

From the physics, we know that this phenomenon is

- time invariant in static scenario,
- and linear. Therefore it is easy to generalize to multiple microphones and sources.

Room Impulse Responses are complicated and long filters that  collects all the element of indoor reverberation and sound interaction with the environments.

However, they a common shape can be identified and illustrated as function of time.

- First there is the so-called direct path, with describe the time and amplitude of the sound reaching the receiver.
- Second, in order of time we have the early echoes, which are repetition of


### Physics to Signal Processing

Sound is emitted by a sound **source**, propagates and interact with the surrounding the **indoor spaces** and is recorded by a **receiver**, such as a microphones.

In particular, the sound can be absorbed, reflected specularly and diffusely and diffracted.

If we imagine to produce an impulse sound, such as a clap or a gun shot. In the recording of the sound we will observe first the sound itself, called the direct path. Then some reflection will arrive and finally all the reflection will accumulate.

In light of signal processing and communication theory, we can model this process as a **input-channel-output system**. The channel is characterized by the so-called **impulse response** and the relation between input and output is express mathematically by the convolution operator. Therefore in our context, this is called **room impulse response**, $h$.

Several element can be identified in the **RIR**.

- the direct path is the line-of-sight contribution of the sound wave.
- the early echoes comprise few disjoint specular reflection coming from room surface. They are typically characterized by **sparsity** in the time and amplitude prominence greater than the later contributions.
- the late reverberation collects all the later reflection.

Note that if we assume the **anechoic** condition...
**Continuous echo model here**

*Transition How do we model this in computer? This quantities are continuous....*

### Signal Processing to Digital signal processing

The **RIR** account for the filtering effect due to sound propagation from a source to a microphone in a indoor space:

$$\tilde{x}(t) = (\tilde{h} \ast \tilde{s})(t) $$
$$h(t) = \sum_k^K \delta{t - \tau_k}$$

Unfortunately, these quantities are not accessible as they are continuous.

Through the use of microphones, our window into the continuous physical world of acoustics is narrow, both it time and in frequency.

In particular what we **observe** is the sampling version of $x(t)$, namely $x[n]$ where $n$ is a integer multiple of the sampling frequency

Here, we decide to model this as the linear convolution between the digital version of the filter $h[n]$ and the digital version of the source signal $s[n]$. Not that this is general is not true and some approximation are made.

### Echo Model

Finally we will use the following model.

Type of noise

- interference
- measurement error
- diffuse noise sources

### 1 Interim Conclusion

- TODO

## Echo Estimation / Retrieval

### Intro on acoustic echo estimation

First we need to estimate the echoes properties.
Early echoes are defined as elements of the room impulse response


### Blaster

### Lantern

### 2 Interim Conclusion

## Echo Application

### Echo-aware applications

### SSL - MIRAGE

### SSS - Separake

### 3 Interim Conclusion

## Echo-aware dataset

### Motivation

### Recording & Annotation

### Validation

- TOA estimation
- Beamforming
- Room Geometry Estimation

### 4 Interim Conclusion

## Conclusion

### Summary of the interim conclusion

### Assets and maps

### Perfective

### Other stuff

- Locata
- Jsm
- Teaching
- MBSSLocate
- Pyroomacoustics

