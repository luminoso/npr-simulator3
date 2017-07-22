# Network Performance And Dimension simulators

This is the 3rd simulator of 4 developed at Universidade de Aveiro at the course [47064 - Network and Performance and Dimension](https://www.ua.pt/uc/2306) in which is is addressed the issue of resource management in network systems and introduce the main techniques of performance analysis and design (stochastic modeling and simulation of discrete events).

The available developed simulator tool set is the following:

 * [Simulator 1](https://github.com/luminoso/npr-simulator1): Connectivity performance of multi-hop wireless networks with mobile terminals
 * [Simulator 2](https://github.com/luminoso/npr-simulator2): Impact of transmission errors in network performance
 * [Simulator 3](https://github.com/luminoso/npr-simulator3): (this project) Blocking performance of video-streaming services
 * [Simulator 4](https://github.com/luminoso/npr-simulator4): Traffic Engineering of packet switched networks

All simulators run both in Matlab or Octave.


## Simulator 3 - Blocking performance of video-streaming services

The aim of this simulator is to assess the blocking performance of video-streaming services. In its simplest form, these services are provided by a single video-streaming server, as illustrated in the following figure:

<p align="center"> 
	<img src="https://github.com/luminoso/npr-simulator3/raw/master/doc/simulator3_preamble1.png">
</p>

At each point in time, the server has a catalogue of movies, each one with a given duration, to be selected by the service subscribers. Movies are available in one or more video formats, depending on the targeted types of subscribers and/or the revenue strategy of the company. In alternative, the service is provided by a farm of servers, located on a single site, as illustrated in the following figure:

<p align="center">
	<img src="https://github.com/luminoso/npr-simulator3/raw/master/doc/simulator3_preamble2.png">
</p>

The aim of a server farm is:

 1. To scale the service to a larger number of subscribers
 2. To make the service robust to single server failures. 

Finally, in its most general architecture, the service is provided by multiple server farms on different sites, as illustrated in the next figure: 
 
<p align="center"> 
	<img src="https://github.com/luminoso/npr-simulator3/raw/master/doc/simulator3_preamble3.png">
</p>
 
The aim of having multiple server farms is:

 1. To scale the services to even larger number of subscribers
 2. To lower the average routing distance (and, consequently, round-trip-time) between subscriber locations and server locations
 3. To make the service robust not only to single server failures but also to single site failures. 

In this case, the number of server farms and, for each farm, its location, its number of servers and its Internet connection capacity is a layout problem which typically involves some sort of optimization.

### Simulation 3.1: Single server

In this simualtion, a video-streaming service is provided by a single server whose Internet connection has a capacity of *C* (in Mbps). We considered that the server provides movies on a single video format and each movie has a throughput of *M* (in Mbps). When a movie is requested by a subscriber, it starts being transmitted by the server if the resulting total throughput is within the Internet connection capacity; otherwise, the request is blocked. We also considered that movie requests are a Poisson process with an average rate of *λ* (in requests/hour) and also that the movies duration is an exponential distributed random variable with average duration *1/μ* (in minutes).

This simualtion was modeled using an *[M/M/m/m](https://en.wikipedia.org/wiki/M/M/c_queue)* queuing system with a capacity of *N* units and offereced load of *ρ* Earlans, where the load is composed by a flow of requests where each request is for 1 unit of the server. The EarlangB formula E(ρ,N):

<p align="center"> 
<img src="https://latex.codecogs.com/svg.latex?%5Clarge%20E%28%5Crho%2CN%29%20%3D%20%5Cfrac%7B%5Cfrac%7B%5Crho%5E%7BN%7D%7D%7BN%21%7D%7D%7B%5Csum_%7Bn%3D0%7D%5E%7BN%7D%5Cfrac%7B%5Crho%5E%7BN%7D%7D%7Bn%21%7D%7D" alt="E(\rho,N) = \frac{\frac{\rho^{N}}{N!}}{\sum_{n=0}^{N}\frac{\rho^{N}}{n!}}">
</p>

gives the probability of a new request being blocked because the server being filly occupied. Since this calculation often has problems (larger values of *ρ* and *N* may cayuse overflow problems) we decomposed the formula, as described in [Guide3_DDR_16_17v2.pdf](doc/Guide3_DDR_16_17v2.pdf).

In the other and, the average server load is calculated by:

<p align="center"> 
	<img src="https://latex.codecogs.com/svg.latex?%5Clarge%20L%28%5Crho%2CN%29%3D%5Cfrac%7B%5Csum_%7Bi%3D1%7D%5E%7BN%7D%5Cfrac%7B%5Crho%5E%7Bi%7D%7D%7B%28i-1%29%21%7D%7D%7B%5Csum_%7Bn%3D0%7D%5E%7BN%7D%5Cfrac%7B%5Crho%5E%7BN%7D%7D%7Bn%21%7D%7D" alt="L(\rho,N)=\frac{\sum_{i=1}^{N}\frac{\rho^{i}}{(i-1)!}}{\sum_{n=0}^{N}\frac{\rho^{N}}{n!}}">
</p>

Recapitulating, the input parameters of *simulator 3.1* are:

| Var | Description                                     |
|-----|-------------------------------------------------|
| C   | Internet connection capacity (in Mbps)          |
| M   | Throughput of each movie (in Mbps)              |
| λ   | Movie request rate (in requests/hour)           |
| 1/μ | Average duration of movies (in minutes)         |
| R   | Number of movie requests to stop the simulation |
| N   | Only update stats after Nth arrival             |

The performance output parameters estimated by this simulator are:

| Var | Description                                                          |
|-----|----------------------------------------------------------------------|
| b   | Blocking probability (percentage of movie requests that are blocked) |
| o   | Average occupation of the Internet connection (in Mbps)              |

This simulator also consideres the following event variables:

| Var       | Description                                      |
|-----------|--------------------------------------------------|
| ARRIVAL   | Event of the time instant of a movie request     |
| DEPARTURE | Event of the time instant of a movie termination |

One state variable:

| Var       | Description                                    |
|-----------|------------------------------------------------|
| STATE     | Total throughput of the movies in transmission |

And statistical counter variables:

| Var       | Description                                                    |
|-----------|----------------------------------------------------------------|
| LOAD      | Number of movie requests to stop the simulation                |
| NARRIVALS | The integral of connection load up to the current time instant |
| BLOCKED   | Number of blocked requests                                     |

The simulator is available at [simulator1_Nth.m](simulator1_Nth.m) and a wrapper that runs it according to [Guide3_DDR_16_17v2.pdf](doc/Guide3_DDR_16_17v2.pdf). (a simpler, more compact version is available at [simulator1.m](simulator1.m), although not recommended, since the system counts all stats before stabilizing)

### Simulation 3.2: Server farm

In a second version of the simulator, the scenario accounts for a video-streaming service provided by one server farm with *S* video-streaming servers where each server has an interface of 100 Mbps (assumed that the Internet connection of the server farm is *C = S × 100 Mbps*). We also considered that the server farm provides movies on 2 possible video formats: a standard format whose throughput is 2 Mbps and a high-definition format whose throughput is 5 Mbps. All movies are available in both formats in all servers. A front-office system assigns requests to servers using a load balancing strategy (i.e. each request is assigned to the least loaded server) and implements an admission control with a resource reservation of *W* (in Mbps) for high-definition movies (i.e., standard movies cannot occupy more than *C – W* Mbps). In more detail, the admission control is as follows:

 * When a high-definition movie is requested, it starts being transmitted by the least loaded server if it has at least 5 Mbps of unused capacity; otherwise, the request is blocked.
 * When a standard movie is requested, it starts being transmitted by the least loaded server if the total throughput of standard movies does not become higher than *C – W* Mbps and the least loaded server has at least 2 Mbps of unused capacity; otherwise, the request is blocked.

Movie requests are a Poisson process with an average rate of *λ* (in requests/hour) and that *p*% of the requests are for high-definition movies. Movies duration is an exponential distributed random variable with average duration *1/μ* (in minutes). 

[simulator2.m](simulator2.m) implements an event driven simulator for this case to estimate the blocking probability of each type of movie requests. Summing up, the variables of the simulation with a server farm has the following input variables:

| Var | Description                                                     |
|-----|-----------------------------------------------------------------|
| λ   | movies request rate (in requests/hour)                          |
| p   | percentage of requests for high-definition movies (in %)        |
| 1/μ | average duration of movies (in minutes)                         |
| S   | number of servers (each server with a capacity of 100 Mbps)     |
| W   | resource reservation for high-definition movies (in Mbps)       |
| Ms  | throughput of movies in standard definition (2 Mbps)            |
| Mh  | throughput of movies in high definition (5 Mbps)                |
| R   | number of movie requests to stop simulation                     |
| N   | movie request number to start updating the statistical counters |

The performance parameters estimated by simulator2 must be:

| Var | Description                                            |
|-----|--------------------------------------------------------|
| bs  | Blocking probability of standard movie requests        |
| bh  | Blocking probability of high-definition movie requests |

These events were considered 

| Var            | Description                                                                   |
|----------------|-------------------------------------------------------------------------------|
| ARRIVAL_S      | time instant of a standard movie request                                      |
| ARRIVAL_H      | time instant of a high-definition movie request                               |
| DEPARTURE_S(i) | time instant of a standard movie termination on server i (i = 1,...,S)        |
| DEPARTURE_H(i) | time instant of a high-definition movie termination on server i (i = 1,...,S) |
|                |                                                                               |

State variables:

| Var      | Description                                                              |
|----------|--------------------------------------------------------------------------|
| STATE(i) | total throughput of the movies in transmission by server i (i = 1,...,S) |
| STATE_S  | total throughput of standard movies in transmission                      |

Statistical counters:

| Var         | Description                                      |
|-------------|--------------------------------------------------|
| NARRIVALS   | total number of movie requests                   |
| NARRIVALS_S | number of standard movie requests                |
| NARRIVALS_H | number of high-definition movie requests         |
| BLOCKED_S   | number of blocked standard movie requests        |
| BLOCKED_H   | number of blocked high-definition movie requests |

#### Results examples

The above simulators export and show results both in CLI and as graphic that represents it. In the graphic below [ex2b.svg](results/ex2b.svg) is the result of the bandwith reservation impact in % of blocked requests:

<p align="center"> 
	<img src="https://github.com/luminoso/npr-simulator3/raw/master/doc/ex2b.svg.png">
</p>

[run_simulator2.m](run_simulator2.m) outputs a representation of the results when running [simulator2.m](simulator2.m) to estimate the lowest blocking probability of the number of servers required vs reservation *W* for each case:

<p align="center"> 
	<img src="https://github.com/luminoso/npr-simulator3/raw/master/doc/view_worsecase_vs_nrservers_3d_complete.svg.png">
</p>


### 3.3 CDN server farm location optimization using Integer Linear Programming (ILP)

In this scenario we considered a service provided by multiple server farms where, again, movies are available in the 2 previous possible video formats and both formats are available or all movies on all servers of all farms. In all farms, each server has an interface of 100 Mbps. In this simulation the Internet part that covers the company targeted subscribers is given by the following figure, which specifies the different types of Autonomous Systems (ASs) and how they are connected (the list of pairs of connected ASs is provided in MATLAB format in Appendix D of [Guide3_DDR_16_17v2.pdf](doc/Guide3_DDR_16_17v2.pdf) and in [simulator3.m](simulator3.m) as *G* var):

<p align="center"> 
	<img src="https://github.com/luminoso/npr-simulator3/raw/master/doc/simulator3_cdn.png">
</p>

Besides determining the total number of servers, the simulataor also needs:
 1. To identify the ASs where the different server farms must be connected
 2. To decide how many servers should be placed on each farm.

Only Tier-2 of Tier-3 ASs provide the Internet access service. The average OPEX costs (Operational Costs) of a server farm is 8 when it is connected to a Tier-2 AS and 6 when it is connected to a Tier-3 AS. The company that streams the videos assumes that it can reach 2500 subscribers on each Tier-2 AS and 1000 subscribers on each Tier-3 AS with average requests of 2 movies per week per customer in the prime time and 20% of requests for high-definition movies. 

We have a set of Autonomous Systems (ASs) and we aim to select a subset of ASs to connect one server farm on each selected AS. The solution must guarantee that in the network of ASs, there is a path between each Tier-2 (and Tier-3) AS and at least one server farm with no more than one intermediate AS. Consider the following notation:

| Var | Description |
|------|---------------------------------------------------------------------------------------------------------------------------------------|
| n | number of Tier-2 (and Tier-3) ASs where server farms can be connected to |
| ci | OPEX cost of connecting a server farm to AS i, with 1 ≤ i ≤ n |
| I(j) | set of Tier-2 (and Tier-3) ASs such that there is a shortest path between AS j and each AS i ∈ I(j) with at most one intermediate AS. |

[NEOS server](https://neos-server.org/neos/solvers/index.html) was used to solve this this ILP problem. Sample of the ASCII file submittion with the described problem is at [ex3_minimize.lp](ex3_minimize.lp) the result of the computation is available at [result_neos.txt](results/result_neos.txt)

## License
MIT
