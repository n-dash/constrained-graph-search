# Optimization of Mixed-Mode Commutes Using Constrained Dijkstra’s Search

## Description

Current navigation tools like Google Maps typically require users to select a single mode of transportation—walking, public transit, driving, or flying—when calculating routes. While they may offer multiple options within a chosen mode, they do not optimize routes that combine walking and public transit in a way that balances travel, walking, and waiting times. As a result, transit-heavy routes can include long and inefficient waits between transfers. **This project implements a route optimization system that asks the user for the maximum number of minutes they are willing to walk and computes the fastest route combining walking and public transit, while respecting the walking-time constraint.**

## Motivation 

This project was inspired by a real-life commute problem in Toronto, Canada. For example, when traveling from Finch Subway Station to Toronto Pearson Airport—Terminal 1, Google Maps might suggest taking a subway followed by a bus like so:

<p align="center">
<img width="191" height="525" alt="Finch to Pearson commute" src="https://github.com/user-attachments/assets/bf484296-6bce-4680-9f37-92b2a99ec219" /> </p>

However, since the bus only comes every 60 minutes, the user will face a long wait at the transfer point. The optimized mixed-mode model, on the other hand, allows the user to specify a walking limit and can then suggest walking between stops when appropriate to reduce total travel time. This minimizes long waits (especially advantageous during cold Toronto winters!) and promotes a more active and efficient commute.

## Technical Description

The transportation network is modeled as a weighted graph:
- Nodes represent locations such as bus stops, the start point, and the destination.
- Edges represent walking or public transit segments, weighted by travel time (including transit wait time).

The task is formulated as a constrained shortest path problem: minimize total travel time while ensuring that total walking time does not exceed the user-specified limit.

The program is based on Dijkstra’s search, most commonly used algorithm for commute optimization tasks. The modifed Dijkstra’s search evaluates whether walking between nearby stops, or directly toward the destination, can reduce overall travel time. The final output includes:
- Baseline route: a ride-only route for comparison.
- Optimized mixed-mode route: a route combining walking and transit, respecting the time-walking constraint.

This design demonstrates how graph-based algorithms can be applied to real-world transportation problems with multiple edge types, constraints, and user preferences. The project is written in Racket and applies the concepts of graphs, search, encapsulation, abstract functions, interactive world programs, and systematic software design. It was designed during the <a href="https://www.letsbuidl.com" target="_blank">BU1DL program</a> under the mentorship of <a href="https://www.linkedin.com/in/charlieshuchen/" target="_blank">Charlie Chen</a> and Kieran Stewart.

## Demonstration

Consider the following graph:

<p align="center">
<img width="70%" height="70%" alt="original graph" src="https://github.com/user-attachments/assets/1e5ca906-be91-454a-b3b2-4612ec20d1f3" /> </p>


**Note: the fastest route available is highlighted in green**

The baseline model (default Dijkstra’s search) considers ride-only option and produces the following output:

<p align="center">
<img width="70%" height="50%" alt="Screenshot 2025-12-24 at 18 20 19" src="https://github.com/user-attachments/assets/52d4c96b-023f-480a-8010-53299e079655" /> </p>


The mixed-mode model (modified Dijkstra’s search) will suggest different pathways, depending on the user's walk limit.
- Case 1: walk limit = 10 minutes. Both models output the same result because walking between stops does not reduce the commute time if the total time the user is willing to walk is 10 minutes.

<p align="center">
<img width="100%" height="59" alt="10limit" src="https://github.com/user-attachments/assets/c12d7a64-bc73-459c-8a2c-aa1c69370eb2" /> </p>

- Case 2: walk limit = 30 minutes. The mixed-mode model found a more efficient pathway where walking between stops C to F and F to H reduces the commute to 68 minutes, while keeping the total time walked under 30 minutes. 

<p align="center">
<img width="100%" height="59" alt="30limit" src="https://github.com/user-attachments/assets/6c2cf1ac-657a-41cd-b843-e1ae8255cab0" /> </p>

- Case 3: walk limit = 50 minutes. The mixed-mode model found a more efficient pathway where walking start to C, C to F and F to H reduces the commute to 62 minutes, while keeping the total time walked under 50 minutes. 

<p align="center">
<img width="100%" height="59" alt="50limit" src="https://github.com/user-attachments/assets/7b58aa13-a2bd-4802-a071-31cb7974335c" /> </p>

- Case 4: walk limit = 90 minutes. The mixed-mode model found a more efficient pathway where walking from start to destination reduces the commute to 59 minutes, while keeping the total time walked under 90 minutes. 

<p align="center">
<img width="100%" height="58" alt="90limit" src="https://github.com/user-attachments/assets/23988cea-935b-4259-8ccd-e6636866f13f" /> </p>

## Future Improvements

1. Create a user-friendly interface for specifying the walk limit and graph they want to use.
2. Calculate the exact waiting time that is replaced by walking. Currently, the weights for public transit segments combine both waiting and riding time for simplicity, which does not allow to determine the precise amount of time saved by walking instead of waiting.
3. Create a more polished rendering of the model outputs, including a visualization of the graph with the optimal pathways highlighted.
