# Plan of slides

## Introduction

Good morning everyone and thanks to being here today.

The title of my PhD thesis is:
Echo-aware Signal Processing for Audio Scene Analysis.
and this was supervised by Nancy Bertin from the team Panama in INRIA Rennes and
Antoine Deleforge from the team Multispeech in INRIA Nancy

In a nutshell, this thesis deal with the problem of estimating acoustic echoes and use their information to leverage typical problems of audio signal processing.

Before going in the details of the contribution, I will better explain the title

and to this end,

### Audio scene / Scenario

Let us consider how sound is being recorded at this very moment on my laptop.

At first, the sound is produced by sound sources, in this case, myself.
And in general, it can be also produced by other speakers or music instruments.

Secondly, the sound is recorded by multiple microphones of my laptop, namely a microphone array.
These microphones convert sound into electrical signals than are analyzed and processed by some software, for instance, to be transmitted to you.

However in general the sound can be corrupted by other interfering sources and by measurement noise.

And more important, before reaching the laptop, the sound propagates in space, interacting with it especially when we are indoor scenario
This lead to the well-known reverberation effect.

### Audio Scene Analysis

You on the other side, listen to the microphone recordings.
And even without watching the camera you may understand and infer some information.

That is because sound carries information.

We can retrieve from it semantic information about the nature of the sound source and its content --- for instance, the words of my speech.

We can retrieve spatial information on the location of the sources in the space --- for instance, that I am closer or further away from the microphones.

And finally temporal information, about when a sound source is active or not.

All of this information create what we called an audio scene.
And our brain is particularly efficient to process and organize the information within.

So, can a computer do this as well?

### Signal Processing

Computer and digital systems implement units based on signal processing models, frameworks and tools that extracts and organizes information from sounds.

These units typically address specific problems, such as
 separating or enhancing a target sound form the rest,
or say where a sound source is,
or quantify the amount of reverberation affecting sound recordings
and many others

The problems are well-known problems each of those produced large and vast literature that spans many years of research.

In can be noticed that these problems are strictly related to some natural questions, such as
Who is speaking,
Where is the speaker,
What is the content of the speech,

And all of them are naturally interconnected:
For instance, knowing how sound propagates in a space, can help in localizing the sound sources, which can help later in isolating their them and therefore extracting their semantic content.


### Echo aware approach

Exactly, for this reason, today we focus on how sound propagates indoor.

it can be reflected on surfaces, it can be absorbed or transmitted.
And when it is reflected it can be specularly like a mirror and diffusely, namely scattered around.

When indoor, all of these lead to a complex result called reverberation.

From a physical point of view, Acoustic echoes are specular reflections which stand out in the overall reverberation effect in terms of their strength and timing.

More commonly, they are repetitions of sound that usually arrive shortly later.

So they carry the same content of the sound source
and its delay is related to the distance that the sound travel

and this information can be expoiled

Probably the most striking example of this are bats that use of echoes is to navigate and hunt in the dark. But also some cetacea and also it is at the base of the sonar technology.

In signal processing, the sound propagation is typically either ignored to simplify the processing or modelled it fully, which is very challengin

The echo-aware processing offers an attractive alternative that allows better modelling, while not requiring to fully estimate the sound propagation.

This was particularly underlined by a paper from Microsoft Research Group, titled turning enemy into friends, referring to echoes for the task of sound source localization.

### Outline and contribution

To summarize the title:
Audio Scene Analysis give us problems we want to solve;
Signal processing give us models and tools;
And echoes give us useful information that can be used for better processing.

This thesis work aims at improving the current state-of-the-art signal processing along three axes
ESTIMATION, APPLICATION and DATA.

Regarding estimation, we present two approaches:
one is an analytical method based on the continuous dictionary and one is based on a deep learning model.
In contrast with the state of the art, both the methods do not require any parameter tuning or the modelling of the entire sound field.

The second part of this thesis focuses on extending existing methods in audio scene analysis to their echo-aware forms.
The manuscript shows examples in Sound Source Localization, Separation, Speech Enhancement and Room Geometry Estimation.

Finally, since most of the validation of the proposed methods is conducted only on synthetic data and no dataset has been yet proposed in the literature for specific echo-aware processing, we collected our data and we propose as a new database dubbed dEchorate.

The presentation of today will cover partially the manuscript, highlighting to the major contribution of the thesis.
The first part is dedicated to the two estimation methods,
the second part will present an echo-aware application in sound source localization, and we will conclude with the presentation of the dataset with its validation on Speech Enhancement.

For more details, you can see the manuscript.

## Problem statement

In the following slides, we will see how signals and echoes are modelled in the context of audio digital signal processing.

### Signal Model

The complete reverberation includes all the interaction of the sound travelling from a source and reaching a microphone.

In math, we see that the continuous-time signal of the microphone corresponds to the time-domain convolution between the source signal and a filter plus a noise term.

This filter is commonly known as room impulse response and it describes the acoustic response of the room to a perfect impulsive sound.

For this reason, it depends on spatial and acoustic properties of the environments such as the position of the microphones and source, the room shape and size, and the type of material the surfaces are covered with. Because of this, each RIR is different for each position of source and microphone pairs and room.

### Echoes in the RIR

A room impulse response can be subdivided into 3 parts corresponding to  different physical moments:

The direct path is the contribution of the line-of-sight propagation from the mic to the source.

The early reflection or simply echoes comprise few disjoint reflections coming typically from room surfaces and are usually characterized by sparsity in the time domain and amplitude prominence greater than the later reflections.

The latter part is the late reverberation and collects many reflections occurring simultaneously. This part is characterized by a diffuse sound field with exponentially decreasing energy.

Based on this observation, the Room Impulse Response can be approximated at first as a stream of impulses, in math Dirac deltas located at the time of arrival of the reflection.

Plus, a noise term that model later echos and reverberation tail.

The goal of acoustic echo retrieval is to retrieve the time of arrival and the amplitude of such reflections from the microphone recordings.

Usually, more attention is paid on the estimation of the time of arrival only, since it has direct application to source localization and geometry estimation.

### Challenges

Acoustic Echo Retrieval is an extremely challenging task, complicated by the following effects:

First, the shape of the RIRs is highly sensitive to the geometrical properties of the audio scene.

Second, the recordings typically feature reverberation making this under modelling term not ignorable. And recordings also are corrupted by external noise from other sources or due to the measurement process.

And finally, the amplitude coefficient of the echoes are distorted by physical effects (such as frequency-dependent coefficient) and processing effect (such as sampling).

In fact, the arrival of the echoes is continuos value while our signal in the computers are not.
The process of sampling echoes, which involve sync kernel, blur out the true location and amplitude of the echo.
Most important, notice that the signal is no more sparse and non-negative.

As we will see later, this is pathological issues that affect methods assuming the RIR are discrete-domain signals.


## Acoustic Echo Retrieval

Now we will introduce briefly the state of the art in acoustic echoes retrieval and then we will move to the contributions.

### AER

Our task is to retrieve echo times of arrival and amplitude from microphones recordings.

This can be pursued typically in two types of scenario: active or passive.

In the former case, the emitted signal is known.

This makes the problem of estimating the filters and its components, non-blind, so easier.
The payoff is that our device needs to sense the environment by emitting sound actively or knowing the attended sound apriori, which limited the possible use-cases.
This can be used for sonar, device calibration or acoustic measurements.

Alternatively, passive systems are more common in everyday application such as smart speakers or laptop performing passive recording.
But, as the source signal is unknown, the task is much harder.

In general, we will assume to be in the challenging scenario of a passive system listening to a single source.

In a passive setting, two are the main approaches that can be found in the literature:
the one that estimates echoes after having estimated the room impulse response and the one that directly estimates them.

### Passive AER

For the first case, the Room Impulse Response is assumed to be a discrete vector and use some optimization tools to estimate it.
After it, the echoes are identified as the strongest peaks using peak picking or peak labelling strategies.

The main benefit of this approach is that the first step is a well-studied inverse problem for which many successful frameworks and reliable solvers are available and it can count on a vast literature even the specific case of RIR estimation.

And they perform reasonably well on some applications.

However, they suffer from some important drawbacks.
First, the full RIR need to be estimated leading to some computational and memory issues.
Secondly, the peak picking operation cannot be easily automatized and it needs to be tuned manually.
And finally, they suffer on some pathological issues due to their discrete modelling, that I will illustrate in the following slide.

To overcome this limitation, the other methods performs the estimation directly in the parameter space of the echo model, such as delays and amplitudes, using maximum-likelihood approaches.

The main benefit is that the RIR are not estimated entirely saving memory and complexity and since there is no peak-picking less hyperparameter tuning is needed.

Moreover, here the echoes are truly sparse and non-negative since the sampling process is explicitly considered in the model.

The main drawbacks of this approach is that are very recent and not investigated fully.
Ad-hoc powerful solvers or frameworks that can be used out-of-the-box are not present.

Our contribution belongs to this category.
Now I will present the solution with deep learning.

### Deep Learning

The first proposed model for acoustic echo retrieval is based on deep learning.

In particular, it uses the framework of virtually-supervised learning, where the data are generated synthetically by the virtual simulator.

We will consider the simple case of estimating only the time of arrival of the first echo at a mic pair.

On one hand, this case is simple, on the other it has direct application to sound source localization as we will see in the next section.

This approach is motived by

First, we notice that estimating echo properties form raw recordings is difficult, but the inverse is not.
In fact, this is the job of virtual acoustic simulators that from the characteristic of an audio scene can compute full room impulse response, its parameters and a reverberated microphone recordings.

These simulators are simple, versatile and fast, allowing the user to generate as many data as he wants, which is known to be good for deep learning models.

Finally, this whole idea of virtually supersized learning is currently an active direction in Sound Source Localization and it is not only limited to DNN, but also other learning models such as gaussian mixture model.

### Deep Learning Model

Deep Neural Network is a supervised learning model, namely, that learn from examples.

These examples are based on input/output pairs and the model learns the function that maps the input to the output.

In our case, the inputs are the ILD and IPD which corresponds to the magnitude and phase of the ratio between the spectra of the two microphones.
It can be shown that this ratio approximate in some cases the ratio between the spectrum of the two room impulse response removing the dependences on the input signal.

As output, we consider the time of arrival of the direct path and the first echo on both of the channels.
To be more precise, instead of taking this with respect to the origin of time, which is unknown is the passive scenario.
We consider only the three Time Difference of Arrival of these elements with respect to the arrival of the direct path of the first microphones.

We consider two types of models: a simple fully connected and a Conv. Neural Network which is a popular model in machine learning and in sound source localization methods.

We consider 3 different cost function:
one is the common root mean squared error on the TDOAs of interest,
and two based on Gaussian and Student-T log-likelihood.
In this latter case, for each TDOA, the network outputs the value of the mean, the variance and in case of student t distribution the scale too.

This re-parametrization of the output of the DNN is useful for doing data-fusion and allows the network to say its level of confidence on the estimation.

Finally, we use data generated by acoustic simulator which return RIRs and echo annotation automatically. Then observation is generated by convolving the RIRs with white noise signals and some additive gaussian noise is added.

### Deep Learning Model Test

To validate the performances, we tested the proposed methods against the baseline GCC-PHAT with can only recover the TDOAs between the two direct path and not the echoes.

As a performance metric, we consider the normalized Root Mean Square, for which the lower the better, and when it is equal to 1 means that the fit is not better than random.
This was chosen to be able to compare TDOAs that span different ranges.

Here are the results of GCC-PHAT for TDOA estimation.
And we can see that even a simple Fully Connected model can outperform the task and GCC-PHAT can retrieve only direct path TDOAs.

Secondly, we see that the CNN model outperform the fully connected in term of both error and variance indicating more robustness to noise.
Anyway, this is expected and CNN is many complex models with more parameters than simple Fully Connected.

Finally, we can see that using log-likelihood cost function reduce again the error and the variance of the estimation, even if there no significant difference between the Gaussian and Student-T.

Finally, we can observe that TDOA between echoes is a more channelling task.

Now we will move one


### BLASTER

#### State of the art

The next contribution address explicitly the limitation of the state of the art methods which here described.

The key ingredient of these methods is the clever observation that in presence of no noise, two channels commute with respect to the convolution operation with their filters.
This property undergoes with the name of cross-relation identity.

Now, assuming that we have access the sample version of the microphones signal, and assuming that echoes are multiple of the sampling rate,
acoustic echo retrieval can be formulated as finding two sparse vectors than minimize a LASSO-like problem.

Here the cost function comprises the error on the cross-relation plus a regularizer promoting sparsity and constraints imposing non-negativity and avoid non-trivial solution.

This approach has been studied and further extended including different types of constraint and ad-hoc regularizers.

The two main drawbacks here are that the full filters of fixed length need to be estimated and the echoes are not necessarily on the grid leading to the before-mentioned limitation.

#### proposed method
We proposed here another direction which results from a collaboration with a colleague of mine, Clement Elvira, whose expertise is in superresulution for inverse problem.

First, we can write the cross-relation in the continuous frequency domain, where the convolution becomes a product.

Secondly, as the filter is modelled as a train of Diracs, we know how to write its closed-form in the Fourier domain, namely, as a sum of complex exponentials.

Finally, the continuous-time Fourier transform can be well approximated by the DFT operator when many samples are available which is the case for our audio signals.

We can then re-write the previous discrete-time LASSO problem as an instance of Beurling LASSO, which is the continuous domain equivalent.

Note that now the solutions are no-more discrete vectors, a small collection of Diracs.

Therefore, there is no need for computing huge matrices, but only the DFT of the observed signals.

The so-called Total Variation norm here promotes a solution that a linear combination of Diracs which is exactly what we are looking for and it is somehow similar to the l1 norm used in the discrete case.

Then we add non-negativity constraints and anchor constraint which is used to avoid the trivial solution.

The problem can be solved using a gradient descent methods called Sliding Frank Wolk Algorithm recently proposed.

#### Results

We observe promising results on noiseless synthetic data with filters matching the echo-model, namely, we model only the early part of the room impulse response.

This leads us to consider noisy synthetic data where the long filter with long reverberation tail is taken into account.

We generate thousand RIRs for cuboid room of random volumes where two microphones and one sound source are randomly deployed.

RIRs are generated with Image Source Methods implemented by the  Pyroomacoustics library.

The source can be either white noise and speech.

In order to study the performances, 2 datasets have been generated:
one varying randomly the level of noise (ake SNR) while keeping fixed the amount of reverberation (measured in RT60).
Conversely, the other by fixing the noise level and drawing random level of reverberation.

For comparison, we choose 2 discrete-time RIR-based methods
which are based on the discrete-time LASSO problem.

Our methods is dubbed Blaster which stands for Blind And Sparse Technique for Echo Retrieval.

#### Results # Echo Precsion

At first, we compare these methods in function of the precision and  number of echoes we want to retrieve

Precision measures how many estimated echoes are correct, so the higher the better.

We can plot this metric here for both noise and speech source signal.

And we can see at first that the proposed method coloured in RED leads to comparable results to the state of the art coloured in BLUE
which both outperform the baseline in GREEN.

However, we can see that the proposed method is more sensitive to the number of echoes and the source signal.

Note that we can recover accurately the first two echoes, which is promising, since the practical advance of knowing 2 or 3 echoes per channel has been demonstrated in the echo-aware application in source separation and localization.

#### Results RT60 Error

Considering now the task of predicting the time of arrival of the first SEVEN strongest echoes we plot here the performances in term of Room Mean Squared Error with confidence bar, so here the lower the better.

By row, we can see the performance with respect to SNR and RT60, by column with respect to the source signal.

In general, the error on the echo timing of the proposed approach is significantly smaller due to its off-grid nature of the method.

And some robustness is shown with respect to noise and reverberation level as no significant trends are observed

However again we can see that the performances depend on the nature of the sound source, as a higher error is observed on speech data.

We are currently working to address these limitations. For instance
by pre-processing the input observation, considering the Relative Transfer Function instead of the raw DFT of the observation --- a direction suggested by a similar and very recent work.
extend the estimation to a multichannel array and ever consider to exploit the array geometry which in some application is known a priori.
and test on real data

## Echo aware Application

After having seen some ways to estimate the echoes, we can pass at the second part of this presentation which focuses on extending methods in audio scene analysis to their echo-aware forms.

### SOTA

As we said earlier, the echoes carry the same energy content of the sound source, but they arrive later and possibly from a different direction.

These time and direction depend on the geometry of the audio scene.

Let s consider the following example:

2 microphones listening to a target sound source and an interfering one is placed between them.

As you can see the inteferer hide the direct propagation path of the target.

Now, if we consider the reflections instead, we can have a new point of view of the source. This is called the image source model.

However, another perfectly equivalent model exists, which instead of mirroring the source, mirror the microphones and the same properties holds.

From the signal processing point of view, instead, this makes a difference, since we access to more microphones and more microphones means typically better processing capabilities.

Based on this intuition, many researchers included echoes in signal processing application.

In particular, in sound source separation and speech enhancement some methods try to gather the source energy of the echoes which is otherwise lost.

For the geometry-based task, the concept of image source is used to better estimate the position of the source or the microphones, or conversely the surface position, allowing to retrieve in some case the full geometry of the room.

And finally, as an element of the sound propagation, the echoes provide important cues for the entire room impulse response and also properties of interest for acousticians.

I will now discuss the application on Sound Source Localization and Speech Enhancement, while in the manuscript you can find details on sound source separation and room geometry estimation.

### SSL

The task of sound source localization is to estimate the position of the target sound source in the space.

Retrieving the full 3D cartesian position of a sound source is very challenging and typically the problem is relaxed to direction of arrival estimation, where the distance is ignored.

Depending on the number of microphones available, the are two types of Direction on Arrival estimation.

With only 2 microphones, only one angle in the microphone frame can be estimated.

This is typically called Angle of Arrival estimation and knowing the distance between the microphone pair, it can be re-casted as a TDOAs estimation problem, which can be solved with well know GCC-PHAT method.

Instead, when multiple microphones are available the direction of arrival (or DoA) can be estimated knowing the array geometry and the Angle of Arrival for each microphone pair.

For this occasion, some algorithm such as SPR-PHAT consider histograms of possible TDOAs for each pair of microphones and aggregate all the contribution with respect to the global reference point.


### Mirage

We can this idea of aggregating the multiple microphones with the proposed echo-aware method for Sound Source Localization.

Consider the following example where a single source is recorded by two microphones placed close to a surface.

We consider only a single microphone pair because it can be further generalizable to any array geometry.

And we consider the close-reflective surface scenario so the strongest echoes are also the earliest and the absorption coefficient can be fairly assumed frequency independent.

And moreover, it has a direct application to tabletop devices such as smart speakers.

Now, resolving the reflections with the image microphone model we can expand the array.

We will refer to this as the MIRAGE array, where mirage stands for Microphone Array Augmentation with Echoes.

However, how do we access all the microphones pair?

For the application in Sound Source Localization, we are interested in the time difference of arrival between the microphones.

It turns out that these quantities are related to the echos, as we can define the real TDOAs as the difference between the two direct paths.

The image TDOA as the difference between the first echoes

and the time difference of Echoe, or TDOE as the time difference between the arrival of the direct path and its first echo.

### Proposed approach

Therefore the key idea here to use Multiple Microphone SSL method on the Mirage array.

and if you notice, these are the same TDOAs that we estimated with the Deep Learning model in the first part.

Therefore the proposed approach uses the TDOAs estimated with the MLP model and the estimation are fused knowing the position of the two microphones with respect to the surface and we used the error on the validation set as a measure of uncertainty.

We compare this method with GCCPHAT we can access the TDOAs of the true microphones.

### Results

The two methods are tested on a synthetic data of the strongly echoic condition when two microphones are placed close to a reflector attending a sound source randomly placed in the room.

The performances will be reported in terms of accuracy, that is the percentage of correctly guessed

At first, we can compare the performances for the tast of retrieving only the angle of arrival, namely the real TDOAs.

For a noiseless recording featuring white noise source and we can see that mirage perform slightly worse but still comparable and in a range of 20 degree of error both the methods guess the position of the source with 97%.

When we add external noise, GCCPHAT outperform the proposed methods even if the performances drop with respect to the noiseless case. While this is expected for the baseline method, it suggests us that a simple deep model is not able to generalize to noise data.

This is happening also with speech data. While the PHAT transform help of the baseline method makes it robust to the sparse spectrum of the speech, a simple DNN is not able to generalize to this data and it suggests that more powerful models and features should be taken into account.

The following table reports the performances for the task of Direction of Arrival estimation, that is both azimth and elevation.

We can see that the proposed model allows DoA estimation with an accuracy of 79% for azimuth and 88% for elevation for white noise source in noiseless condition.
While it is slightly able to generalize to speech, the performances drop.

And finally, we should mention that these performances reflect the poor performances on echo estimation.

## Echo-aware dataset

All the methodologies presented so far where evaluated on synthetic data.
This is a common procedure in many audio signal processing research.

- collecting and annotating exhaustive data covering much application is a tedious task
- (echo-aware methods) annotation of early echoes require expertise and equipment
- (learning methods) lot of data and acoustic scenario
- (acoustic simulators) acoustic simulators can reach a good level of approximation (some applications)
  - SSL
  - ASR (\cite{Google})

For all these reasons, many works are validated on simulated data.
Nevertheless, real data are necessary to validate the approaches and many RIRs databases are available online.

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
  - $\Rightarrow$ the contains strong echoes, but no multichannel arrays, nor multiple speakers or various RT60

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
