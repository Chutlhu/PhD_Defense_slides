# Plan of slides

## Introduction

### Scenario

Let us consider our current pandemic scenario:

We are all at home, inter-facing each others with a computer which is recording us.
Currently the microphones of your computer are hopefully capturing my sound.

We need to ignore the post-processing of the video-conference tools
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
All these makes the audio scene we are immersed into.

### Audio Scene Analysis

### Signal Processing

### Echo aware approach

### Outline 1D

### Outline 2D

## Modeling

*Transition: How do we model the echoes and a sound effected by echoes?*

### Physics to Signal Processing

Sound is emitted by a sound **source**, propagates and interact with the surrounding the **indoor spaces** and is recorded by a **receiver**, such as a microphones.

In particular, the sound can be absorbed, reflected specularly and diffusely and diffracted.

If we imagine to produce an impulse sound, such as a clap or a gun shot. In the recording of the sound we will observe first the sound itself, called the direct path. Then some reflection will arrive and finally all the reflection will accumulate.

In light of signal processing and communication theory, we can model this process as a **input-channel-output system**. The channel is characterized by the so-called **impulse response** and the relation between input and output is express mathematically by the convolution operator. Therefore in our context, this is called **room impulse response**, $h$.

Several element can be identified in the **RIR**.

- the direct path is the line-of-sight contribution of the sound wave.
- the early echoes comprise few disjoint specular reflection coming from room surface. They are typically characterized by **sparsity** in the time and amplitude prominence greater than the later contributions.
- the late reverberation callects all the later reflection.

Note that if we assume the **anechoic** condition...
**Continuous echo model here**

*Transition How do we model this in computer? This quantities are continuous....*

### Signal Processing to Digital signal processing

The **RIR** account for the filtering effect due to sound propagation from a source to a microphone in a indoor space:

$$x(t) = (h \ast s)(t) $$
$$h(t) = \sum_k^K \delta{t - \tau_k}$$

Unfortunately, these quantities are not accessible as they are continuous.

Through the use of microphones, our window into the continuous physical world of acoustics is narrow, both it time and in frequency.

In particular what we **observe** is the sampling version of $x(t)$, namely $x[n]$ where $n$ is a integer multiple of the sampling frequency

Here, we decide to model this as the linear convolution between the digital version of the filter $h[n]$ and the digital version of the source signal $s[n]$. Not that this is general is not true and some approximation are made.

### Echo Model

## Echo Estimation / Retrieval
