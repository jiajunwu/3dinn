# Single Image 3D Interpreter Network

This repository contains pre-trained models and evaluation code for the project 'Single Image 3D Interpreter Network' (ECCV 2016). 

http://3dinterpreter.csail.mit.edu

## Prerequisites
#### Torch
We use Torch 7 (http://torch.ch) for our implementation.

#### fb.mattorch and Matlab (optional)
We use `.mat` file with [`fb.mattorch`](https://github.com/facebook/fblualib/tree/master/fblualib/mattorch) for saving results, and `Matlab` (R2015a or later, with Computer Vision System Toolbox) for visualization. 

## Installation
Our current release has been tested on Ubuntu 14.04.

#### Clone the repository
```sh
git clone git@github.com:jiajunwu/3dinn.git
```
#### Download pretrained models (1.8GB) 
```sh
cd 3dinn
./download_models.sh
``` 

## Steps for evaluation

#### I) List input images in `data/[classname].txt`

#### II) Estimate 3D object structure 

The file (`src/main.lua`) has the following options.
- `-gpuID`:  specifies the gpu to run on (1-indexed)
- `-class`: which model to use for evaluation. Our current release contains four models: `chair`, `swivelchair`, `bed`, and `sofa`.
- `-batchSize`: the batch size to use 

Sample usages include
- Estimate chair structure for images listed in `data/class.txt`
```sh
cd src
th main.lua -gpuID 1 -class chair 
``` 

#### III) Check visualization in `www`, and estimated parameters in `results`  

## Sample input & output

<table>
<tr>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/input/chair_00000001.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/output/chair_00000001.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/input/chair_00000002.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/output/chair_00000002.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/input/chair_00000003.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/output/chair_00000003.jpg" height="160"></td>
</tr>
<tr>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/input/swivelchair_00000003.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/output/swivelchair_00000003.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/input/swivelchair_00000004.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/output/swivelchair_00000004.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/input/swivelchair_00000001.png" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/output/swivelchair_00000001.jpg" height="160"></td>
</tr>
<tr>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/input/bed_00000003.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/output/bed_00000003.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/input/bed_00000002.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/output/bed_00000002.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/input/bed_00000001.png" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/output/bed_00000001.jpg" height="160"></td>
</tr>
<tr>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/input/sofa_00000003.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/output/sofa_00000003.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/input/sofa_00000002.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/output/sofa_00000002.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/input/sofa_00000001.jpg" height="160"></td>
<td><img src="http://3dinterpreter.csail.mit.edu/repo/output/sofa_00000001.jpg" height="160"></td>
</tr>
</table>


## Datasets we used

- Keypoint-5 dataset [(zip, 208MB)](http://3dinterpreter.csail.mit.edu/data/keypoint-5.zip)

- Extended IKEA dataset with additional 3D keypoint labels [(zip, 171MB)](http://3dinterpreter.csail.mit.edu/data/ikea_3DINN.zip)

- [SUN Database](http://groups.csail.mit.edu/vision/SUN/)

## Reference

    @inproceedings{3dinterpreter,
      title={{Single Image 3D Interpreter Network}},
      author={Wu, Jiajun and Xue, Tianfan and Lim, Joseph J and Tian, Yuandong and Tenenbaum, Joshua B and Torralba, Antonio and Freeman, William T},
      booktitle={European Conference on Computer Vision},
      pages={365--382},
      year={2016}
    }

For any questions, please contact Jiajun Wu (jiajunwu@mit.edu) and Tianfan Xue (tfxue@mit.edu).
