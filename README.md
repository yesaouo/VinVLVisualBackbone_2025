# VinVL VisualBackbone 2025

🚀 **2025 年快速可用的 VinVL 視覺骨幹模型** - 解決原版環境配置複雜、模型連結失效等問題，讓你幾分鐘內開始使用！

## 📖 專案概述

本專案是基於 Microsoft 的 [scene_graph_benchmark](https://github.com/microsoft/scene_graph_benchmark) 的 **2025 年現代化重構版本**，專為快速部署和使用而設計：

- **VinVL 視覺骨幹模型**：高性能的物件檢測和特徵提取
- **場景圖生成**：理解圖像中物件間的關係
- **多模型支援**：包含 IMP、MSDN、GRCNN、Neural Motif、RelDN 等算法
- **易用 API**：簡化的接口，幾行代碼即可開始使用
- **Docker 支援**：一鍵部署，免環境配置煩惱

> ⚠️ **重要提醒**: 本專案使用 **Git LFS** 來管理大型模型文件，請確保在克隆後執行 `git lfs pull` 來下載模型。

## ✨ 核心特性

- **🎯 物件檢測**：精確識別圖像中的物件和屬性
- **🔗 關係檢測**：理解物件間的空間和語義關係  
- **📊 特徵提取**：提取高品質的 2054 維視覺特徵
- **⚡ 快速推理**：批次處理，支援多圖像同時推理
- **🐳 Docker 部署**：一鍵運行，零配置煩惱

## 🚀 3 分鐘快速開始

### 📦 Docker 一鍵運行（推薦）

```bash
# 直接下載 Dockerfile 並運行
curl -O https://raw.githubusercontent.com/yesaouo/VinVLVisualBackbone_2025/main/Dockerfile
docker build -t vinvl-2025 . && docker run --gpus all -it vinvl-2025
```

### ⚡ 立即測試

```python
from scene_graph_benchmark.wrappers import VinVLVisualBackbone

# 初始化（自動下載模型）
detector = VinVLVisualBackbone()

# 處理圖像
results = detector("demo/woman_fish.jpg")
print(f"檢測到 {len(results['boxes'])} 個物件")
```

## 📦 安裝指南

### 🐳 Docker 部署（推薦）

```bash
# 基本運行
docker build -t vinvl-2025 .
docker run --gpus all -it vinvl-2025

# 掛載本地目錄
docker run --gpus all -it \
  -v /path/to/images:/workspace/images \
  vinvl-2025
```

### 🔧 手動安裝

```bash
# 克隆專案（需要 git lfs 支援）
git clone https://github.com/yesaouo/VinVLVisualBackbone_2025.git
cd VinVLVisualBackbone_2025

# 下載模型文件（重要！）
git lfs install  # 如果尚未安裝 git lfs
git lfs pull      # 下載大型模型文件

# 創建環境
conda create --name vinvl2025 python=3.8 -y
conda activate vinvl2025

# 安裝依賴
conda install pytorch==1.7.1 torchvision==0.8.2 cudatoolkit=10.1 -c pytorch
pip install -r requirements.txt

# 構建模組
cd scene_graph_benchmark/
python setup.py build develop
```

## 💡 使用範例

### 🎯 基本使用

```python
from scene_graph_benchmark.wrappers import VinVLVisualBackbone

detector = VinVLVisualBackbone()
results = detector("your_image.jpg")

# 查看結果
print(f"檢測到 {len(results['boxes'])} 個物件")
for cls, score in zip(results['classes'], results['scores']):
    print(f"- {cls}: {score:.2f}")
```

### 🔍 特徵提取

```python
import numpy as np

# 完整 2054 維特徵
features = np.concatenate([
    results['features'],        # 2048 維
    results['spatial_features'] # 6 維
], axis=1)

print(f"特徵形狀: {features.shape}")
```

### 🖼️ 批次處理

```python
from pathlib import Path

# 處理多張圖像
for img_path in Path("images/").glob("*.jpg"):
    results = detector(str(img_path))
    print(f"{img_path.name}: {len(results['boxes'])} 個物件")
```

### 🔍 完整特徵提取

```python
import numpy as np

# 獲取完整的 2054 維視覺特徵
visual_features = np.concatenate([
    results['features'],        # 2048 維視覺特徵
    results['spatial_features'] # 6 維空間特徵
], axis=1)

print(f"特徵形狀: {visual_features.shape}")  # (物件數量, 2054)

# 保存特徵
np.save("image_features.npy", visual_features)
```

### 🖼️ 批次處理多張圖像

```python
import os
from pathlib import Path

# 批次處理目錄中的所有圖像
image_dir = "your_images/"
results_all = {}

for img_file in Path(image_dir).glob("*.jpg"):
    print(f"處理: {img_file}")
    results = detector(str(img_file))
    results_all[img_file.name] = {
        'objects_count': len(results['boxes']),
        'features': results['features'],
        'classes': results['classes']
    }

print(f"總共處理了 {len(results_all)} 張圖像")
```

### 🎨 可視化

```bash
# 物件檢測
python tools/demo/demo_image.py \
    --config_file sgg_configs/vgattr/vinvl_x152c4.yaml \
    --img_file demo/woman_fish.jpg \
    --save_file output/demo.jpg

# 關係檢測  
python tools/demo/demo_image.py \
    --config_file sgg_configs/vrd/R152FPN_vrd_reldn.yaml \
    --img_file demo/woman_fish.jpg \
    --save_file output/relations.jpg \
    --visualize_relation
```

## 📊 模型性能

### VinVL 模型規格
- **架構**: ResNeXt-152 + FPN  
- **特徵維度**: 2048 (視覺) + 6 (空間) = 2054
- **檢測類別**: 1,600+ 物件類別

### 場景圖模型 (Visual Genome)

| 模型 | SGDet@20 | SGCls@20 | PredCls@20 |
|------|:--------:|:--------:|:----------:|
| IMP | 21.7 | 29.3 | 48.8 |
| MSDN | 22.4 | 29.7 | 51.2 |
| Neural Motif | 21.8 | 30.2 | 52.1 |
| GRCNN | 22.9 | 30.5 | 52.1 |
| RelDN | 24.0 | 31.9 | 54.0 |

## 🆚 原版對比

| 特性 | 原版 | VinVL 2025 |
|------|:----:|:---------:|
| 🚀 **部署** | 複雜配置 | Docker 一鍵 |
| 📦 **模型** | 連結失效 | 自動下載 |
| 📚 **文檔** | 英文簡陋 | 中文完整 |
| ⚡ **上手** | 幾小時 | 幾分鐘 |

## 📚 參考資料

- 🔗 [原始專案](https://github.com/microsoft/scene_graph_benchmark)
- 📄 [VinVL 論文](https://arxiv.org/abs/2101.00529)  
- 📊 [模型詳情](scene_graph_benchmark/SCENE_GRAPH_MODEL_ZOO.md)

## 📁 專案結構

```
VinVLVisualBackbone_2025/
├── Dockerfile                  # Docker 部署文件
├── README.md                   # 專案說明文件
├── requirements.txt            # Python 依賴
├── vinvl_README.md             # VinVL 原始說明
├── scene_graph_benchmark/      # 場景圖檢測核心模組
│   ├── configs/                # 模型配置文件
│   ├── demo/                   # 演示圖像和腳本
│   ├── maskrcnn_benchmark/     # 檢測模型實現
│   ├── scene_graph_benchmark/  # 場景圖相關模組
│   ├── sgg_configs/            # 場景圖配置
│   ├── tools/                  # 工具腳本
│   └── models/                 # 預訓練模型目錄
└── docker/                     # Docker 相關文件
```

## 🎨 應用場景

### 🖼️ 圖像理解
- **內容分析**: 自動分析圖像內容和結構
- **場景描述**: 生成詳細的圖像描述
- **視覺問答**: 回答關於圖像內容的問題

### 🤖 多模態 AI
- **視覺語言模型**: 為 VL 模型提供高品質視覺特徵
- **圖像檢索**: 基於語義的圖像搜索
- **內容生成**: 輔助圖像標題生成

### 🔍 計算機視覺研究
- **特徵提取**: 為下游任務提供預訓練特徵
- **基準測試**: 場景圖生成算法評估
- **模型比較**: 不同視覺模型效果對比

## 🛠️ 常見問題

### ❓ 模型問題

**Q: 模型下載失敗？**
```bash
# 確保已安裝 git lfs
git lfs install

# 下載模型文件
git lfs pull

# 檢查模型目錄
ls scene_graph_benchmark/models/vinvl_vg_x152c4/
# 應包含: vinvl_vg_x152c4.pth 和 VG-SGG-dicts-vgoi6-clipped.json

# 如果仍然失敗，可以手動檢查 LFS 狀態
git lfs ls-files
```

**Q: GPU 記憶體不足？**
```python
# 降低批次大小
opts = {"TEST.IMS_PER_BATCH": 1}
detector = VinVLVisualBackbone(opts=opts)
```

**Q: 檢測速度慢？**
```python
# 提高置信度閾值
opts = {"MODEL.ROI_HEADS.SCORE_THRESH": 0.5}
detector = VinVLVisualBackbone(opts=opts)
```

## 📚 參考資料

### 相關論文

```bibtex
@inproceedings{zhang2021vinvl,
  title={Vinvl: Revisiting visual representations in vision-language models},
  author={Zhang, Pengchuan and Li, Xiujun and Hu, Xiaowei and Yang, Jianwei and Zhang, Lei and Wang, Lijuan and Choi, Yejin and Gao, Jianfeng},
  booktitle={Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition},
  pages={5579--5588},
  year={2021}
}

@misc{han2021image,
  title={Image Scene Graph Generation (SGG) Benchmark}, 
  author={Xiaotian Han and Jianwei Yang and Houdong Hu and Lei Zhang and Jianfeng Gao and Pengchuan Zhang},
  year={2021},
  eprint={2107.12604},
  archivePrefix={arXiv},
  primaryClass={cs.CV}
}
```

### 相關連結

- 🔗 [原始專案](https://github.com/microsoft/scene_graph_benchmark)
- 📄 [VinVL 論文](https://arxiv.org/abs/2101.00529)
- 📊 [模型庫詳情](scene_graph_benchmark/SCENE_GRAPH_MODEL_ZOO.md)
- 🔧 [安裝指南](scene_graph_benchmark/INSTALL.md)

## 📄 授權條款

本專案基於 MIT 授權條款開源。詳見 [LICENSE](scene_graph_benchmark/LICENSE) 文件。

## 🤝 貢獻指南

歡迎提交 Issue 和 Pull Request！請參考：
- [貢獻指南](scene_graph_benchmark/CONTRIBUTING.md)
- [行為準則](scene_graph_benchmark/CODE_OF_CONDUCT.md)

## 🆘 支援與幫助

如有問題或需要幫助，請：
1. 查看 [疑難排解](scene_graph_benchmark/TROUBLESHOOTING.md)
2. 搜尋現有 [Issues](https://github.com/yesaouo/VinVLVisualBackbone_2025/issues)
3. 提交新的 Issue

## 💝 致謝

感謝 Microsoft Research 團隊提供的原始 VinVL 模型和 scene_graph_benchmark 框架。本專案旨在讓這個優秀的視覺模型在 2025 年更容易使用。

---

💡 **記住**: 如果你是第一次使用，強烈建議從 Docker 版本開始，這能避免 99% 的環境問題！
