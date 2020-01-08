# Final-Project-of-TSP
This is my final project for the Combinatrial Optimization course in Padua University.

The project description is as following:
# Lab 1

## Methods and Models for Combinatorial Optimization
## Lab exercise - Part I
## L. De Giovanni, M. Di Summa
Consider the following combinatorial optimization problem and the proposed Integer Linear Programming (ILP) model. The exercise is to implement the model using the Cplex API (Computer Scientist) or OPL (Others) and to test it. Test should determine the ability of the model to provide exact solutions for the proposed problem: in particular we want to know up to which size (namely the number of holes) the problem can be solved in different amounts of time (up to 0.1 seconds, up to 1 second, up to 10 seconds ...).

# Problem description
A company produces boards with holes used to build electric panels (see Figure 1). Boards
are positioned over a machine and a drill moves over the board, stops at the desired
positions and makes the holes. Once a board is drilled, a new board is positioned and
the process is iterated many times. Given the position of the holes on the board, the
company asks us to determine the hole sequence that minimizes the total drilling time,
taking into account that the time needed for making an hole is the same and constant for
all the holes.

## Lab exercise - Part I
## 2 Mathematical formulation
## 2.1 Modelling framework
We can represent the problem on a weighted complete graph G = (N, A), where N is the set of nodes and corresponds to the set of the positions where holes have to be made, and A is the set of the arcs (i, j), ∀ i, j ∈ N, corresponding to the trajectory of the drill moving from hole i to hole j. A weight cij can be associated to each arc (i, j) ∈ A, corresponding to the time needed to move from i to j. In this graph model, the problem can be seen as finding the path of minimum weight that visits all the nodes. Indeed, since the drill
has to come back to the initial position in order to start with the next board, the path has to be a cycle. The problem can be thus seen as determining the minimum weight hamiltonian cycle on G, that is a Travelling Salesman Problem (TSP) on G.

## 2.2 Mathematical Programming models
Several formulations for the TSP have been formulated based on (Miced) Integer Linear Programming. Some of them include an exponential number of constraints (see Lecture Notes on ”Exact methods for TSP”) and, in practice. they cannot be directly implemented using basic Cplex API or basic OPL (they require a row generation procedure). We then focus on compact formulations, i.e., formulations that requirer a polynomial (possibly with small degree) number of variables and constraints.
In the following, we suggest a possible compact formulation based on network flows. It is not the only available compact formulation: you may search the literature for an alternative compact formulation and consider the opportunity of implementing it (this would be appreciated, in particular for OPL implementation).

## 2.3 A possible model based on network flows
The TSP can be formulated (among others) as a network flow model on G. Arbitrarily select a node in N (call it node 0) as starting node, and let |N| − 1 be the amount of its outgoing flow. The idea is to push this amount of flow towards the remaining nodes in such a way that (i) each node (different from 0) receives 1 unit of flow, (ii) each node is visited once, and (iii) the sum of cij over all the arcs shipping some flow is minimum.

### Sets: 
• N = graph nodes, representing the holes;
• A = arcs (i, j), ∀ i, j ∈ N, representing the trajectory covered by the drill to move from hole i to hole j.
### Parameters: 
• cij = time taken by the drill to move from i to j, ∀ (i, j) ∈ A; • 0 = arbitrarily selected starting node, 0 ∈ N.

### Decision variables:
• xij= amount of the flow shipped from i to j, ∀ (i, j) ∈ A; 
• yij= 1 if arc (i, j) ships some flow, 0 otherwise, ∀ (i, j) ∈ A.
