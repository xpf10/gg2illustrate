# gg2illustrate

`gg2illustrate` 是一个轻量级 ggplot2 辅助包，用于在最终成图尺寸下设置字号和线宽，并导出更便于在 Adobe Illustrator 中整理的 PDF。

## 安装

从 GitHub 安装最新版本：

```r
install.packages("remotes")
remotes::install_github("xpf10/gg2illustrate")
```

如需同时导出便于在 Illustrator 中编辑的 SVG，再安装可选依赖：

```r
install.packages(c("svglite", "xml2", "systemfonts"))
```

也可以下载源码后，在项目目录运行：

```r
install.packages("ggplot2")
install.packages(".", repos = NULL, type = "source")
```

需要带 Cairo 支持的 R。运行 `capabilities("cairo")` 应返回 `TRUE`。使用的字体也须安装在导出图像的电脑上。

## 函数帮助

安装后可在 R 中查看完整参数和示例：

```r
library(gg2illustrate)
?gg2illustrate
?ggsave_illustrate
?theme_illustrate
```

| 函数 | 用途 |
| --- | --- |
| `ggsave_illustrate()` | 按期刊常用尺寸导出 Cairo PDF，可选同时导出 SVG |
| `theme_illustrate()` | ggplot2 基础主题，字号和主题线宽以 pt 传入 |
| `theme_illustrate_pubr()` | 用于 ggpubr 图形及 `ggarrange()` 的主题 |
| `label_log()` | 创建单段 Unicode 对数下标标签 |
| `linewidth_pt()` | 将 pt 线宽换算为 ggplot2 `linewidth` 参数 |
| `fontsize_pt()` | 将 pt 字号换算为文本 geom 的 `size` 参数 |
| `stroke_pt()` | 将 pt 换算为点形状边框的 `stroke` 参数 |

## 快速使用

```r
library(ggplot2)
library(gg2illustrate)

df <- data.frame(
  log2_fc = c(-2, -1, 0, 1, 2),
  response = c(1.2, 1.8, 2.4, 3.0, 3.4)
)

p <- ggplot(df, aes(log2_fc, response)) +
  geom_line(linewidth = linewidth_pt(0.5)) +
  geom_point(size = 1) +
  labs(
    x = label_log(2, "Fold change"),
    y = "Response (a.u.)"
  ) +
  theme_illustrate(
    text_pt = 6.5,
    axis_text_pt = 6,
    axis_title_pt = 7,
    line_pt = 0.5,
    family = "Arial"
  )

ggsave_illustrate("figure.pdf", p, column = "single", height_mm = 65)
```

单栏宽度默认 90 mm，双栏默认 180 mm；例如 `column = "double"`。自定义宽度可传 `width_mm`。`geom_text(size = fontsize_pt(6))` 可按 pt 设置图内注释字号；也可写 `geom_text(size = 6, size.unit = "pt")`。点的轮廓可写 `geom_point(shape = 21, stroke = stroke_pt(0.5))`。ggplot2 的主题字号本身就以 pt 为单位，因此无需转换。[ggplot2 的线宽存在历史比例差异](https://ggplot2.tidyverse.org/articles/ggplot2-specs.html)，本包已在换算中考虑；线宽在不同图形设备上仍可能有细微差异，最终以导出的 PDF 为准。

### ggpubr 常用图形

`ggscatter()`、`ggboxplot()`、`ggviolin()`、`ggbarplot()`、`ggline()`、`ggdensity()`、`gghistogram()`、`ggdotplot()` 和 `ggpaired()` 都可通过 `ggtheme = theme_illustrate_pubr()` 采用相同的字体、字号和坐标轴线宽。此主题使用设备通用的 `sans`，避免 `ggarrange()` 排版时因直接指定 Arial 出现 PostScript 字体警告；Windows 上 SVG 的 `sans` 通常映射为 Arial，而含下标的 SVG 标签仍会自动使用有相应字形的字体（本机为 Segoe UI）。

```r
library(ggpubr)
figure_theme <- theme_illustrate_pubr()
example <- data.frame(log2_fc = c(-2, -1, 0, 1, 2),
                      response = c(1.2, 1.8, 2.4, 3.0, 3.4))

box <- ggboxplot(ToothGrowth, x = "dose", y = "len",
                 linewidth = linewidth_pt(0.5),
                 ggtheme = figure_theme) +
  stat_compare_means(size = fontsize_pt(6))

scatter <- ggscatter(example, x = "log2_fc", y = "response",
                     xlab = label_log(2, "Fold change"),
                     ggtheme = figure_theme)

figure <- ggarrange(scatter, box, ncol = 2, labels = c("a", "b"),
                    font.label = list(size = 8, family = "sans"))
ggsave_illustrate("ggpubr-figure.pdf", figure, column = "double",
                  height_mm = 90, svg_copy = TRUE)
```

`ggarrange()` 请先给各子图设置主题，再组合；组合后的单页图可直接导出。多页 `ggarrange()` 返回的是图列表，目前需逐页导出。`linewidth_pt()` 可用于支持 `linewidth` 的 ggpubr 函数；散点 `size`、箱体 `width` 等参数不是线宽，仍按 ggpubr 自身的含义设置。统计标注的 `size` 可用 `fontsize_pt()` 换算。

### ggrepel 与其他扩展包

对于沿用 ggplot2 图层接口的扩展包，可直接组合基础主题和单位换算函数。`ggrepel` 是可选依赖，标签字号可继续用 `fontsize_pt()`：

```r
install.packages("ggrepel")

library(ggplot2)
library(gg2illustrate)

ggplot(mtcars, aes(wt, mpg, label = rownames(mtcars))) +
  geom_point() +
  ggrepel::geom_text_repel(size = fontsize_pt(6)) +
  theme_illustrate(family = "Segoe UI")
```

目前不需要为每个扩展包都增加包装函数。若后续包有不同的单位、主题接口或组合行为，再新增该包的可选适配层；核心依赖保持精简，适配层只在相应扩展包安装时使用。适配函数应各自提供帮助页和示例。

### 下标标签与 Illustrator

原来的 `xlab(expression("log"[2]*"(Fold change)"))` 使用 plotmath 绘制，下标和正文由不同位置的文本片段构成。可改为：

```r
labs(x = label_log(2, "Fold change"))
```

这会生成单个 Unicode 字符串 `log₂(Fold change)`，避免 plotmath 主动拆分。它依赖字体中的下标字形；Cairo PDF 可以嵌入字体并支持 UTF-8。但 PDF 内部仍可能按字体字形分成多个片段，Illustrator 导入后不保证只有一个文本对象。若需要在 Illustrator 中继续编辑，安装 `svglite`、`xml2` 和 `systemfonts` 并同时导出 SVG：

```r
install.packages(c("svglite", "xml2", "systemfonts"))
ggsave_illustrate("figure.pdf", p, svg_copy = TRUE)
```

这会生成同尺寸的 `figure.svg`。为了避免 Illustrator 把下标样式拆成多个文字对象，SVG 中的 `log₂(Fold change)` 保持为单个文本节点。本包会为含下标的标签选择本机安装且包含相关字形的字体；若希望指定字体，可用 `svg_subscript_family = "Calibri"`。打开 SVG 的电脑也须安装同一字体。PDF 可用于提交，SVG 可作为 Illustrator 编辑源文件。复杂公式仍可用 `expression()`，但不能保证在编辑器中保持单段文字。提交前请在目标编辑器中检查字体和文字。

### 期刊规格

预设基于 [Nature 图稿要求](https://research-figure-guide.nature.com/figures/preparing-figures-our-specifications/) 和 [Nature 投稿说明](https://www.nature.com/nature/for-authors/initial-submission)：常规图中文字通常为 5–7 pt，优先 Arial/Helvetica，图宽常用 90/180 mm，推荐可编辑矢量稿。`line_pt = 0.5` 位于其[延伸数据线宽建议](https://research-figure-guide.nature.com/figures/extended-data-formatting-guidelines/)的 0.25–1 pt 范围内。不同 Nature 系列期刊及稿件阶段可能有更具体的要求；这里提供可调整的起点，不自动检查所有图层、嵌入位图或投稿规范。

导出使用 `grDevices::cairo_pdf()`。如图中包含必须栅格化的内容，`fallback_dpi` 默认 450；普通线条和文字仍以矢量方式输出。字体需在本机正确安装，导出后请在目标编辑器中确认文字可编辑、线宽和布局无误。
