# Plan of slides

## Introduction

Good morning everyone and thanks to be here today.

The title of my PhD thesis is:
Echo-aware Signal Processing for Audio Scene Analysis.

In a nutshell, it deals with the problem of estimating acoustic echoes and use their information to leverage typical problem of audio signal processing.


Before going in the details, I will brake down the title of the thesis:

### Audio scene / Scenario

In order to better introduce the topic of the thesis, let us consider how sound is recording in everyday application, for instance this exactly videoconference.

First sound is produced by sound sources, in this case myself, but can be also a speakers or music instruments.
And the sound is recorded by the microphones of my laptop, that we call here microphone array.
This microphones convert sound into electrical signal than are analyzed and used by the device,
for instance to be transmitted to you.

However in general the sound can be corrupted by other sound sources and by measurement noise.

And more important, before reaching the laptop, the sound propagates space, and more in detail it interacts with it especially when we are indoor.
This lead to the well known reverberation effect.

### Audio Scene Analysis

You on the other side, listen to the microphone recordings.
And even without watching the camera you may understand and infer my information.

That is because sound carries information and in particular
semantic information  on the nature of the sound source and its content.
For instance that I am a man, and what I am saying.

But sound carry also spatial information, for instance if I am closer or further, or in a small or big room.
And finally temporal information, about when a sound source is active or note.

All of this information create what we called an audio scene.
And your brain is particular efficient in extract, process and organize the information within.

A key question that we ask with our research here is if we can build system, software even robots that can do this automatically?

### Signal Processing

The sound can be modeled as signal and studied within the research field of Signal Processing.
It offer models, frameworks and tools to extract and organize information from sounds.
This is done by defining the problems.

Typical problems are separating or enhancing a target sound form the rest, or say where a sound source is, or quantify the amount of reverberation or automatically transcribe speech, say who is speaking and many many other.

The problems are well know problem that which produced large and vast literature and are intensively studied.

In can be noticed that these problems are strictly related to the some natural questions, such as Who, What, , When, Where and How. The why is not considered for philosophical reason.

And it should be noticed that this problems are naturally interconnected:
namely the solution of one of these question can be easier if information about the other is available.

For instance knowing the how sound propagates in a space, can help in localizing the sound sources, which can help in isolating their sounds.


### Echo aware approach

Exactly for these reason we focus today on acoustic echoes.

Sound propagates and interact with the surrounding indoor space:
it can be reflected on surfaces, it can be absorbed or transmitted.
And we it is reflected it can be specularly and diffusely.

All of these effects create the complex indoor sound propagation or reverberation.

From a physical point of view, Acoustic echoes are element of reverberation, that is particular specular reflection which stand out for strength and timing.

More commonly, they are are repetition of sound that usually arrive later.
Notice that an echo carry the same sound content and its delay is related to the distance that the sound travel.

We can se this is everyday examples such as in the echo points in the mountains.
Probably the most striking example of the properties of echoes are the bats that use it to
navigate in the dark and hunting. Such techniques is used by dolphins it is a the based of the sonar technology.

In signal processing the sound propagation is typically either ignored or modeled it fully.
In the former case, this assumption lead to huge simplification, but consider reverberation as noise term, as a nuisance. While the latter, the estimation of the full sound propagation effect is very challenging.
The echo-aware processing offer an attractive alternative that allow better modeling, while not requiring to fully estimated the sound propagation.
This was particularly underlined by a paper from Microsoft Research, titled turning enemy into friends, referring to echoes in signal processing.

### Outline and contribution

To summarize the title:
Audio Scene Analysis give us our problems we want to solve;
Signal processing give us models and tools;
And echoes echoes give us useful information that can be used for better processing.

In my PhD I addressed this along 3 directions:
ESTIMATION, APPLICATION and DATA.

The first direction consists in estimating the properties of acoustic echoes, for which we propose two methods, one analytical and one based on machine-learning.
The main different with respect to state of the art is that they do not require any parameter tuning or model the propagation entirely.

In the fist part, we will assume to know the properties of acoustic echoes used for boosting classical audio signal processing methods for sound source separation, sound source localization, speech enhancement and the estimation of the room shape.

Finally, since most of the validation of the above methods is conducted on synthetic data and no dataset have been yet proposed for specific echo-aware processing, we build our own.

The presentation of today will cover partially the manuscript, highlighting to major contribution of the thesis.
The first part is dedicated to the two estimation methods,
the second part will present an echo-aware application in sound source localization
and we will conclude with the presentation of the dataset with its validation on Speech Enhancement.

## Problem statement

In the following slides we will see how signals and echoes are modeled in the context of audio digital signal processing.

### Signal Model

The complete sound propagation include all the interaction of the sound travelling in whole environment starting from a source and reaching a microphone.

In math, it translates as follows.
The continuous time signal of the microphone corresponds to the time-domain convolution between the source signal and such filter, with is commonly known as room impulse response
Note that here the tilde denotes time domain.

The room impulse response is a linear filter that describes the acoustic response of the room to a prefect impulsive sound.
A room impulse response depends on spatial and acoustic properties of the environments such as microphones and source position, room shape and size, and the type of material the surfaces are covered with.
Because of this their are unique for each source and microphone pairs.

### Echoes in the RIR

Because a Room Impulse Response describes the physical response of a room, it can be subdivided in 3 parts of different physical properties:

In particular we can identify the direct path which corresponds to the contribution of the direct propagation sound.
It is commonly followed by a few isolated peaks which correspond to the strongest specular reflection, namely our echoes.
And finally the reverberation tail accounting for later reflection and the diffusion effects.

Based on this observation, the Room Impulse Response can be approximated at first as a stream of impulses, in math Dirac deltas located at the time of arrival of the reflection.

The goal of echoes estimation is retrieve the time of arrival and the amplitude of such reflections.

Acoustic Echo Retrieval is a extremely challenging task, complicated by the following effects:
First the shape of the RIRs is highly sensitive to the geometrical properties of the audio scene.
Second the recordings typically feature reverberation making the this undermodeling term not ignorable. And recordings also are corrupted by noise from other sources or due to the measurement process.
And finally the amplitude coefficient of the echoes are distorted by physical effect (such as frequency dependent absorption coefficient) and processing effect (such as sampling).

In fact the arrival of the echoes are continuos while our signal in the computers are not.
The process of sampling echoes blur out the true location and amplitude of the echo.


## Acoustic Echo Retrieval

Now we will introduce briefly the state of the art in acoustic echoes estimation and I will present you to contribution.

### AER

Acoustic Echo Retrieval is the problem of estimating echoes timings and coefficients.

This can be pursued typically in two type of scenario: active or passive.

In the former case the emitted signal is known.
This make the problem of estimating filter, and therefore, its components, non-blind, so easier.
The payoff is that the device need to sense the environment by emitting with sound actively or knowing the attended sound priori, which can be used in specific setup.
This is typical approach used for sonar, device calibration or acoustic measurements.

On the overside, passive systems are more common in everyday application such as smart spakers or laptop performing passive recording.
As the source signal is unknown the task is much harder.

We will assume to be in single source, passive system scenario.

In passive scenario, two are the main approaches that can be found in the literature:
the one that estimate echoes after having estimate the room impulse response and the one that try to solve this problem directly in the smaller space of the echo parameter, in  few number of delay.

### Passive AER

Both the approaches have pros and cons and here is a summary.

For RIR-based approaches, first the Room Impulse Response is estimated by typically solving a blind channel estimation (or BCE) problem. On the estimation, the echoes are identified as the strongest peaks using peak picking or peak labeling strategies.

The main benefit of this approach is that such approaches rely on well studied frameworks for inverse problem, reliable solver and produced a vast literature even the the case for rir estimation.
Moreover they are currently the state of the art in RIR estimation and perform reasonably well in certain application.

However they suffer of some important drawbacks.
First the full RIR need to be estimated leading to some computational and memory issues.
Secondly the peak picking operation is not straightforward for the distortion on the amplitudes and typically it needs to be tuned manually.
And finally, they suffer on some pathological issues due to their on-grid nature, that I will illustrate in a few slide.

To overcome this limitation, RIR-agnostics perform the estimation directly in the parameter space of the echo model, such as delays and amplitudes, using maximum-likelihood approaches.

The main benefit is that the RIR are not estimated entirely saving memory and complexity and since there is no peak-picking less hyperparameter tuning is needed.

Moreover, here the echoes are truly sparse and non-negative, since we are considering the sampling process explicitly in the model.

The main drawbacks of this approach is that are very recent and not investigated fully.
Ad-hoc powerful solvers or frameworks that can be used out-of-the-box are not present.

### Limitation and bottleneck

A common limitation of the state-of-the-art approaches is that echoes are not necessarily on grid.
This leads to a pathological bodyguard effect where two smaller spikes are estimated instead.

This slow down the converge of the algorithm as well as it affects the performances since peak picking tools need to manually be tuned or corrected.

To avoid this, oversampling could be used, at the cost of two problems:

first it increase the memory usage, since bigger matrices and vectors need to be computed and stored in memory.

and secondly, by increasing the sampling frequency and so the size of the problem, it risk to become ill-conditioned.

To overcome this limitation, we will propose two methods which operate echo estimation directly and off-the-grid: one based on deep learning and one based on the theory of continuous dictionary.


### Deep Learning

The first proposed model for acoustic echo retrieval is based on deep learning models.

In particular it uses the framework of virtually-supervised learning, where the data are generated by virtual simulator.
We will consider the simple case of estimating only the first echo time of arrival in stereophonic recording.
On one hand this case is simple, on the other it has direct application to sound source localization.

The main reason to follow this approach are as follows.

First we notice that estimating echo properties form raw recordings is difficult, but the inverse is not.
In fact, this is the job of virtual acoustic simulators that from the characteristic of an audio scene (such as room size, mic and source position) can compute the echoes times, coefficient, as well as the full room impulse response and if the source signal is provided, also the microphones recordings.

This simulators are simples, versatile and fast, allowing the user to generate many many data, which is known to be good for deep learning models.

Finally this whole idea of virtually supersized learning is currently an active direction in Sound Source Localization, a field that span several year and it is not only limited to neural network, but also other types of learning such as gaussian mixture model.

### Deep Learning Model

Deep Neural Network are supervised learning models, namely that learn from examples.
These examples are based on input/output pairs and the model learning how to estimated the output from the input.

In our case the input are the ILD and IPD which corresponds to the magnitude and phase of the ratio between the spectra of the two microphones.
It can be shown that this ratio approximate in same case the ratio between the two room impulse response and it is independent on the input signal.

As output we consider the time of arrival of the direct path and the first echo on both of the channels.
To be more precise, instead of taking this with respect of the origin of time, which is unknow is passive scenario.
We consider the Time Difference of Arrival of this elements with respect to the arrival of the direct path of the first microphones.

We consider two types of models: a simple Multi Layer Preceptor network and the more common now, the Conv. Neural Network which have been recently proposed in sound source localization methods.

We consider 3 different cost function:
one is the comman root mean squared error on the TDOAs of interest,
and two based on Gaussian and Student-T log-likelihood.
In this latter case, for each TDOA, the network outputs the value of the mean, the variance and in case of student t the mean, the shape and the scale.

These re-parametrization of the output of the DNN is useful for doing data-fusion and allows the network to say its level of certainty on the estimation.

Finally we used data generated by acoustic simulator which return RIRs and annotation of teh echoes. Then observation are generated by convolving the RIRs with white noise signals.

### Deep Learning Model Test

In order to validate the performances, we tested the proposed methods against the baseline GCC-PHAT with is able to only recover the TDOAs between the two direct path and not the echoes.



## Echo-aware dataset

All the methodologies presented so far where evaluated on synthetic data.
This is a common procedure in many audio signal processing research.

- collecting and annotating exhaustive data covering many application is tedious task
- (echo-aware methods) annotation of early echoes require expertise and equipment
- (learning methods) lot of data and acoustic scenario
- (acoustic simulators) acoustic simulators can reach a good level of approximation (some applications)
  - SSL
  - ASR (\cite{Google})

For all these reasons, many works are validated on simulated data.
Nevertheless real data are necessary to validate the approaches and many RIRs databases are available online.

We can divide them broadly in two groups:

- Speech Enhancements oriented databases. They require:
  - different relative DOAs, many sources
  - different level of SNR, RT60, DRR
  - array geometry
  - $\Rightarrow$ the contains strong echoes, but are not annotated, nor the room geometry
- Room Geometry Estimation oriented databases
  - geometrical annotation of src, mic, room
  - different room shapes
  - the signal annotation is partially available (need to be computed a posteriori by the user)
  - $\Rightarrow$ the contains strong echoes, but no multichannel arrays, nor multiple speaker or various RT60

### Recording & Annotation

A good echo-aware methods needs

- good geometrical annotation as well as good signal annotation.
  This two should match
- designed to be used for
  - echo estimation (need for peak annotation)
  - echo-aware signal application (source separation, speech enhancement)
  - echo-aware geometry application (source localization, microphones calibration, room geometry estimation)

The dEchorate database was created to meet this requirements.
It has the following characteristics:
Moreover it has

- many acoustic environment (one-hotted and incremental and fornitures)
- 6 linear array and 4 sources
- position of source and first order image sources annotated and echo annotated
- Code to get real RIRs and *matching* simulated RIRs

Further possibility

- Do some learning due to the quantities of RIRs (>)
- Study the difference between synth and real RIRs

### Annotation

The annotation was done using the following tools:

- The exact knowledge planimetry of the room
- RIR estimation with ESS (Farinas) and a calibrated acquisition system
- and Indoor Positioning System for an initial guess
- Echo annotatation with a GUI visualizing echoes
  - Skyline
  - Manual peak peaking
  - Matched filter (Equalization)
- Exact multilateration algorithm for refinement the position

Limitation

- the exact annotation of the echoes is challenging due to the non ideal loudspeaker
- only nULA
- only first order images (= first k echoes) --- the sometimes the second strongest echoes comes from the ceiling

Learn from my mistakes:

- put a microphone close to the source, always.
- check the loudspeaker characteristics
- etc...

### Validation

In order to validate the dataset and show its potential we considered to following application:

- Acoustic Echo Estimation
  - task: estimate the echoes
  - test against simulated and real RIRs
- Room Geometry Estimation
  - task: estimate the room geometry from knowing echoes
- Echo-aware Speech Enhancement using beamforming
  - task: multichannel denoising and dereverberation
  - test echo-aware vs. echo-agnostic bf
  - test against simulated and real RIRs

#### Room Geometry Estimation

In a nutshell, Room Geometry Estimation can be done from TOAs annotation (label and value)

1. identifying the position of the image source with multilateration (3D extention of trilateration)
    Convex and closed-from, but ill-conditioned by noise. Beck can do that
2. by simply computing the plane that bisects the segments between the source and its image
  this methods is called Images Source Inversion

Many other methods for Room Geometry Estimation exists, they differs based on the knowledge of the labels and the setup.

We can see here an examples of the estimation

If we run this method for all the microphones of one room configuration we obtain the following results:
TABLE HERE

RESULTS HERE

#### Beamforming

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
- Pyroomacoustics -->
