# Pinball loss Twin Support Vector Clustering (pinTSVC)

This is implementation of the paper: M. Tanveer, Tarun Gupta, Miten Shah, and for the Alzheimer’s Disease Neuroimaging Initiative. 2020. Pinball Loss Twin Support Vector Clustering. ACM Trans. Multimedia Comput. Commun. Appl. (Accepted), 23 pages.

Description of files:

readdataset.m: main file to run selected algorithms on datasets. In the path variable specificy the path to the folder containing the datasets on which you wish to run the algorithm. The final results are stored in results.txt file, and the optimal parameters are stored in parameters.txt file.

main_pintsvc.m: selecting parameters of pintsvc algorithm and k value of k fold cross-validation. One can select paramters c (denoted by variable csv1), mu (denoted by variable mus) and tau (denoted by variable taus) to be used in grid-search method.

pintsvc.m: implementation of proposed pinTSVC algorithm. Takes paramters c, mu, tau, training data and test data and provides accuracy obtained and running time.

adding_noise.m: Adding zero-mean Gaussian noise of different standard deviations on datasets. Variable rs refers to standard deviation of non-zero Gaussian noise.

For quickly reproducing the results of the pinTSVC algorithm, we have made a Dataset folder containing a sample dataset. One can simply run the readdataset.m file to check the obtained results on this sample dataset. To run experiments on more datasets, simply add datasets in the Dataset folder and run readdataset.m file. The code has been tested on Windows 10 with MATLAB R2017a.

Please cite the following paper if you are using this code.

Reference: M. Tanveer, Tarun Gupta, Miten Shah, and for the Alzheimer’s Disease Neuroimaging Initiative. 2020. Pinball Loss Twin Support Vector Clustering. ACM Trans. Multimedia Comput. Commun. Appl. 1, 1 (May 2020), 23 pages. https://doi.org/10.1145/1122445.1122456

For further details regarding working of algorithm, please refer to the paper.

If further information is required please contact on: tarungupta360@gmail.com or mitenshah16@gmail.com
