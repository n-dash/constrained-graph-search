;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname bu1ld_htdw) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require spd/tags)
(require 2htdp/image)
(require 2htdp/universe)

;; RouteSearch is optimizing mixed-mode commutes using constrained graph search

(@htdw RouteSearch)

;; =================
;; Data Definitions:

(@htdd Edge)
(define-struct edge (to walk-time ride-time))
;; Edge is (make-edge String Natural Natural)
;; interp. next node's name, walk time, ride time (including bus wait time)

(define e1 (make-edge "A" 8 3))
(define e2 (make-edge "DEST" 20 15))
(define e3 (make-edge "B" 4 10))
(define e4 (make-edge "DEST" 5 2))

(@htdd Node)
(define-struct node (name edges))
;; Node is (make-node String (listof Edge))
;; interp. node's name, and list of outgoing edges to next nodes (bus stops)

(define start (make-node "START" (list e1 e2)))
(define a     (make-node "A"     (list e3)))
(define b     (make-node "B"     (list e4)))
(define dest  (make-node "DEST"  empty)) 

(@htdd Step)
(define-struct step (node walk-used total-time path))
;; Step is (make-step String Natural Natural (listof String))
;; interp: a set of accumulators to represent current state of Dijkstra search
;; - node is the current node (bus stop) name
;; - walk-used is the total walking time accumulated
;; - total-time is the total travel time accumulated
;; - path is the list of nodes visited

(define s1 (make-step "A" 0 5 '("START" "A")))
(define s2 (make-step "B" 0 8 '("START" "B")))
(define s3 (make-step "C" 0 10 '("START" "C")))


; Sample graph definitions for testing 
(define graph (list start a b dest))

(define g1-e1 (make-edge "DEST" 20 5))
(define g1-e2 (make-edge "A" 5 10))
(define g1-e3 (make-edge "DEST" 5 20))
(define g1-start (make-node "START" (list g1-e1 g1-e2)))
(define g1-a     (make-node "A"     (list g1-e3)))
(define g1-dest  (make-node "DEST"  empty))
(define graph1 (list g1-start g1-a g1-dest))

(define g2-e1 (make-edge "DEST" 20 20))
(define g2-e2 (make-edge "A" 5 3))
(define g2-e3 (make-edge "B" 5 3))
(define g2-e4 (make-edge "DEST" 5 3))
(define g2-start (make-node "START" (list g2-e1 g2-e2)))
(define g2-a     (make-node "A"     (list g2-e3)))
(define g2-b     (make-node "B"     (list g2-e4)))
(define g2-dest  (make-node "DEST"  empty))
(define graph2 (list g2-start g2-a g2-b g2-dest))

(define g3-e1 (make-edge "A" 5 3))
(define g3-e2 (make-edge "B" 5 4))
(define g3-e3 (make-edge "C" 5 1))
(define g3-e4 (make-edge "DEST" 5 10))
(define g3-start (make-node "START" (list g3-e1)))
(define g3-a     (make-node "A"     (list g3-e2)))
(define g3-b     (make-node "B"     (list g3-e3)))
(define g3-c     (make-node "C"     empty)) 
(define g3-dest  (make-node "DEST"  empty))
(define graph3 (list g3-start g3-a g3-b g3-c g3-dest))

(define g4-e1 (make-edge "A" 5 4))
(define g4-e2 (make-edge "B" 5 4))
(define g4-e3 (make-edge "DEST" 5 6))
(define g4-e4 (make-edge "DEST" 5 6))
(define g4-start (make-node "START" (list g4-e1 g4-e2)))
(define g4-a     (make-node "A"     (list g4-e3)))
(define g4-b     (make-node "B"     (list g4-e4)))
(define g4-dest  (make-node "DEST"  empty))
(define graph4 (list g4-start g4-a g4-b g4-dest))

(define graph5
  (list (make-node "START" empty)))

(define e-sa (make-edge "A" 5 4))
(define e-sb (make-edge "B" 6 6))
(define e-sc (make-edge "C" 8 3))
(define e-ad (make-edge "D" 4 4))
(define e-ae (make-edge "E" 6 5))
(define e-be (make-edge "E" 4 3))
(define e-bf (make-edge "F" 7 6))
(define e-cf (make-edge "F" 3 2))
(define e-dg (make-edge "G" 5 4))
(define e-eg (make-edge "G" 4 6))
(define e-fh (make-edge "H" 6 3))
(define e-gd (make-edge "DEST" 5 4))
(define e-hd (make-edge "DEST" 4 5))
(define n-start (make-node "START" (list e-sa e-sb e-sc)))
(define n-a     (make-node "A"     (list e-ad e-ae)))
(define n-b     (make-node "B"     (list e-be e-bf)))
(define n-c     (make-node "C"     (list e-cf)))
(define n-d     (make-node "D"     (list e-dg)))
(define n-e     (make-node "E"     (list e-eg)))
(define n-f     (make-node "F"     (list e-fh)))
(define n-g     (make-node "G"     (list e-gd)))
(define n-h     (make-node "H"     (list e-hd)))
(define n-dest  (make-node "DEST"  empty))
(define large-graph
  (list n-start n-a n-b n-c n-d n-e n-f n-g n-h n-dest))

(define e-sa2 (make-edge "A" 10 4))
(define e-sb2 (make-edge "B" 12 5))
(define e-sc2 (make-edge "C" 8 6))
(define e-ad2 (make-edge "D" 9 3))
(define e-ae2 (make-edge "E" 15 8))
(define e-be2 (make-edge "E" 7 4))
(define e-bf2 (make-edge "F" 10 3))
(define e-cf2 (make-edge "F" 6 5))
(define e-dg2 (make-edge "G" 12 4))
(define e-eg2 (make-edge "G" 10 5))
(define e-fh2 (make-edge "H" 8 2))
(define e-gd2 (make-edge "DEST" 9 3))
(define e-hd2 (make-edge "DEST" 6 2))
(define n-start2 (make-node "START" (list e-sa2 e-sb2 e-sc2)))
(define n-a2     (make-node "A"     (list e-ad2 e-ae2)))
(define n-b2     (make-node "B"     (list e-be2 e-bf2)))
(define n-c2     (make-node "C"     (list e-cf2)))
(define n-d2     (make-node "D"     (list e-dg2)))
(define n-e2     (make-node "E"     (list e-eg2)))
(define n-f2     (make-node "F"     (list e-fh2)))
(define n-g2     (make-node "G"     (list e-gd2)))
(define n-h2     (make-node "H"     (list e-hd2)))
(define n-dest2  (make-node "DEST"  empty))
(define large-graph2
  (list n-start2 n-a2 n-b2 n-c2 n-d2 n-e2 n-f2 n-g2 n-h2 n-dest2))

(define e-sa3 (make-edge "A" 20 25))
(define e-sb3 (make-edge "B" 24 24))
(define e-sc3 (make-edge "C" 15 18))
(define e-ad3 (make-edge "D" 18 25))
(define e-ae3 (make-edge "E" 30 40))
(define e-be3 (make-edge "E" 12 20))
(define e-bf3 (make-edge "F" 18 25))
(define e-cf3 (make-edge "F" 14 20))
(define e-dg3 (make-edge "G" 22 30))
(define e-eg3 (make-edge "G" 20 28))
(define e-fh3 (make-edge "H" 16 25))
(define e-gd3 (make-edge "DEST" 18 25))
(define e-hd3 (make-edge "DEST" 14 20))
(define n-start3 (make-node "START" (list e-sa3 e-sb3 e-sc3)))
(define n-a3     (make-node "A"     (list e-ad3 e-ae3)))
(define n-b3     (make-node "B"     (list e-be3 e-bf3)))
(define n-c3     (make-node "C"     (list e-cf3)))
(define n-d3     (make-node "D"     (list e-dg3)))
(define n-e3     (make-node "E"     (list e-eg3)))
(define n-f3     (make-node "F"     (list e-fh3)))
(define n-g3     (make-node "G"     (list e-gd3)))
(define n-h3     (make-node "H"     (list e-hd3)))
(define n-dest3  (make-node "DEST"  empty))
(define large-graph3
  (list n-start3 n-a3 n-b3 n-c3 n-d3 n-e3 n-f3 n-g3 n-h3 n-dest3))

(define r1-e1 (make-edge "DEST" 10 2)) 
(define r1-e2 (make-edge "A" 5 5))     
(define r1-e3 (make-edge "DEST" 5 10))
(define r1-start (make-node "START" (list r1-e1 r1-e2)))
(define r1-a     (make-node "A" (list r1-e3)))
(define r1-dest  (make-node "DEST" empty))
(define graph-r1 (list r1-start r1-a r1-dest))

(define r2-e1 (make-edge "A" 8 3))
(define r2-e2 (make-edge "B" 8 3))
(define r2-e3 (make-edge "DEST" 12 5))
(define r2-e4 (make-edge "DEST" 5 12))
(define r2-start (make-node "START" (list r2-e1 r2-e2)))
(define r2-a     (make-node "A" (list r2-e3)))
(define r2-b     (make-node "B" (list r2-e4)))
(define r2-dest  (make-node "DEST" empty))
(define graph-r2 (list r2-start r2-a r2-b r2-dest))

(define r3-e1 (make-edge "A" 6 6))
(define r3-e2 (make-edge "DEST" 20 4))
(define r3-start (make-node "START" (list r3-e1 r3-e2)))
(define r3-a     (make-node "A" (list r3-e2)))
(define r3-dest  (make-node "DEST" empty))
(define graph-r3 (list r3-start r3-a r3-dest))

(define r4-e1 (make-edge "A" 10 2))
(define r4-e2 (make-edge "DEST" 15 3))
(define r4-e3 (make-edge "DEST" 5 5))
(define r4-start (make-node "START" (list r4-e1 r4-e2)))
(define r4-a     (make-node "A" (list r4-e3)))
(define r4-dest  (make-node "DEST" empty))
(define graph-r4 (list r4-start r4-a r4-dest))


(@htdd RouteSearch)
(define-struct rs (walk-limit graph))
;; RouteSearch is (make-rs Natural (listof Node))
;; interp.
;;  - walk-limit is the maximum allowed walking time, constraint set by the user
;;  - graph is the current graph to search

(define initial-rs (make-rs 50 large-graph3))

;; =================
;; Functions:

(@htdf main)
(@signature RouteSearch -> RouteSearch)
;; start the world with (main initial-rs)
;; no tests for htdw-main template

(@template-origin htdw-main)

(define (main rs)
  (big-bang rs
    (to-draw   render)))

(@htdf render)
(@signature RouteSearch -> Image)
;; render paths from both models, total time, walking time, and walking limit

(@template-origin encapsulated RouteSearch)

(define (render rs)
  (local
    [(define baseline (baseline-route (rs-graph rs) "START" "DEST"))
     (define mixed (mixed-mode-route (rs-graph rs) "START" "DEST"
                                     (rs-walk-limit rs)))
     
     (define (path-to-string path)
       (if (empty? (rest path))
           (first path)
           (string-append (first path) " -> " (path-to-string (rest path)))))

     (define (step->text st algo-name)
       (if (false? st)
           (string-append algo-name " No route found")
           (string-append algo-name " "
                          (path-to-string (step-path st))
                          ", Total path time: "
                          (number->string (step-total-time st)) " min"
                          (if (string=? algo-name "Mixed-Mode Path:")
                              (string-append
                               ", Total time walked: "
                               (number->string (step-walk-used st)) " min"
                               ", Constraint on walking time: "
                               (number->string (rs-walk-limit rs)) " min")
                              ""))))

     (define best-time
       (cond
         [(false? baseline) (if (false? mixed) +inf.0 (step-total-time mixed))]
         [(false? mixed) (step-total-time baseline)]
         [else
          (min (step-total-time baseline) (step-total-time mixed))]))

     (define (draw-route st algo-name)
       (if (false? st)
           (text "No route found" 15 "black")
           (overlay/align "center" "bottom"
                          (text (step->text st algo-name) 15 "black")
                          (rectangle
                           (+
                            (image-width (text
                                          (step->text st algo-name)
                                          15 "black")) 10)
                           (+ (image-height
                               (text (step->text st algo-name)
                                     15 "black")) 10)
                           "solid"
                           (if (= (step-total-time st) best-time)
                               "green" "lightgray")))))

     (define (stack-images imgs)
       (if (empty? (rest imgs))
           (first imgs)
           (above (first imgs) (stack-images (rest imgs)))))]
    
    (stack-images
     (list
      (draw-route baseline "Baseline Path:")
      (draw-route mixed "Mixed-Mode Path:")))))


; Helpers 
(@htdf find-node)
(@signature (listof Node) String -> Node or false)
;; produce node with the given name in a list of nodes, or false if not found
(check-expect (find-node (list start a b dest) "A") a)
(check-expect (find-node (list start a b dest) "DEST") dest)
(check-expect (find-node (list start a b dest) "X") false)

(define (find-node nodes name)
  (cond
    [(empty? nodes) false]
    [(string=? (node-name (first nodes)) name) (first nodes)]
    [else
     (find-node (rest nodes) name)])) 

(@htdf neighbors)
(@signature (listof Node) String -> (listof Edge))
;; produce list of edges for the node with the given name in a list of nodes
(check-expect (neighbors (list start a b dest) "START") (node-edges start))
(check-expect (neighbors (list start a b dest) "B") (node-edges b))

(define (neighbors nodes name)
  (node-edges (find-node nodes name))) 

(@htdf insert-sorted)
(@signature Step (listof Step) -> (listof Step))
;; insert a state into a sorted list of states, with list sorted by total-time
(check-expect (insert-sorted s1 empty) (list s1))
(check-expect (insert-sorted s1 (list s2 s3)) (list s1 s2 s3))
(check-expect (insert-sorted s3 (list s1 s2)) (list s1 s2 s3))
(check-expect (insert-sorted s2 (list s1 s3)) (list s1 s2 s3))

(define (insert-sorted st unvisited)
  (cond
    [(empty? unvisited) (list st)]
    [(< (step-total-time st) (step-total-time (first unvisited)))
     (cons st unvisited)]
    [else
     (cons (first unvisited)
           (insert-sorted st (rest unvisited)))]))

; Baseline Dijkstra’s search algorithm
(@htdf baseline-route)
(@signature (listof Node) String String -> Step or false)
;; produce fastest route between start & dest nodes, or false if no route exists
(check-expect (step-node (baseline-route graph "START" "DEST")) "DEST")
(check-expect (baseline-route graph5 "START" "START")
              (make-step "START" 0 0 (list "START")))
(check-expect (baseline-route graph5 "START" "DEST") false)

(@template-origin genrec accumulator)

(define (baseline-route nodes start-name dest-name)
  ;; unvisited is (listof Step); worklist accumulator of unvisited states,
  ;;                              sorted by shortest total travel time
  ;; visited is (listof String); results-so-far accumulator with names of nodes
  ;;                             already visited
  (local [(define (baseline-loop unvisited visited)
            (cond
              [(empty? unvisited) false]
              [(string=? (step-node (first unvisited)) dest-name)
               (first unvisited)]
              [(member? (step-node (first unvisited)) visited)
               (baseline-loop (rest unvisited) visited)]
              [else
               (baseline-loop
                (foldl insert-sorted
                       (rest unvisited)
                       (map (lambda (e)
                              (make-step (edge-to e)
                                         0
                                         (+ (step-total-time
                                             (first unvisited))
                                            (edge-ride-time e))
                                         (append (step-path (first unvisited))
                                                 (list (edge-to e)))))
                            (neighbors nodes (step-node (first unvisited)))))
                (cons (step-node (first unvisited)) visited))]))]
    (baseline-loop
     (list (make-step start-name 0 0 (list start-name)))
     empty)))

; Mixed-mode Dijkstra’s constrained search algorithm 
(@htdf mixed-mode-route)
(@signature (listof Node) String String Natural -> Step or false)
;; produce mixed-mode route, minimizing total time while staying below
;; walking-time limit or false if no such route exists
(check-expect (step-node (mixed-mode-route graph "START" "DEST" 50)) "DEST")
(check-expect (mixed-mode-route graph5 "START" "DEST" 50) false)
(check-expect (mixed-mode-route graph5 "START" "START" 10)
              (make-step "START" 0 0 (list "START")))


(@template-origin genrec accumulator)

(define (mixed-mode-route nodes start-name dest-name walk-limit)
  ;; unvisited is (listof Step); a worklist of search states still left to
  ;;                             explore, sorted by total-time
  ;; visited is (listof (list String Natural)); accumulator with states
  ;;                                            already processed
  (local
    [(define (seen? node walk-used visited)
       (ormap (lambda (v) (and (string=? (first v) node)
                               (= (second v) walk-used))) visited))

     (define (mixed-loop unvisited visited)
       (cond
         [(empty? unvisited) false]
         [(string=? (step-node (first unvisited)) dest-name) (first unvisited)]
         [(seen? (step-node (first unvisited))
                 (step-walk-used (first unvisited)) visited)
          (mixed-loop (rest unvisited) visited)]
         [else
          (mixed-loop (foldl insert-sorted (rest unvisited)
                             (foldr
                              append empty
                              (map
                               (lambda (e)
                                 (append
                                  (list
                                   (make-step
                                    (edge-to e)
                                    (step-walk-used (first unvisited))
                                    (+ (step-total-time (first unvisited))
                                       (edge-ride-time e))
                                    (append (step-path (first unvisited))
                                            (list (edge-to e)))))
                                  (if (<= (+ (step-walk-used (first unvisited))
                                             (edge-walk-time e))
                                          walk-limit)
                                      (list
                                       (make-step
                                        (edge-to e)
                                        (+ (step-walk-used (first unvisited))
                                           (edge-walk-time e))
                                        (+ (step-total-time (first unvisited))
                                           (edge-walk-time e))
                                        (append (step-path (first unvisited))
                                                (list (edge-to e)))))
                                      empty)))
                               (neighbors nodes
                                          (step-node (first unvisited))))))
                      (cons
                       (list (step-node (first unvisited))
                             (step-walk-used (first unvisited)))
                       visited))]))]
    (mixed-loop
     (list (make-step start-name 0 0 (list start-name)))
     empty)))
