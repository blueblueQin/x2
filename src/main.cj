package x2

import std.io.*
import std.collection.*

func string_to_int64(s: String) : Int64 {
    var result: Int64 = 0

    for (ch in s.runes()) {
        // 这里的关键：字符要先转换为数字
        let char_code = Int64(UInt32(ch))-Int64(UInt32(r'0'))
        let digit_value = UInt32(ch) - UInt32(r'0')  // 获取0-9的值
        if (let Some(dv) <- (char_code as Int64)) {
            // 非数字字符，处理错误（这里简单返回0）
            result = result * 10 + dv
        }

    }
    
    return result
}

// 使用


func parse_numbers(s: String) : ArrayList<Int64> {
    // 思路1: 用 replace() 去掉方括号，再用 split() 分割
    // 思路2: 逐个字符读取，累积数字
    let list = ArrayList<Int64>(100)
    // 示例框架:
    let clean = s.replace("[", "").replace("]", "")
    let parts = clean.split(",")

    for (part in parts) {
        let num = string_to_int64(part)
        list.add(num)
        
        // 将字符串转为数字（用你知道的方法）
        // nums.add(转换结果)
    }
    
    return list
}

// 构建区间
func build_intervals(nums: ArrayList<Int64>) : ArrayList<ArrayList<Int64>> {
    var intervals = ArrayList<ArrayList<Int64>>()
    
    for (i in 0..nums.size/2) {
        // 创建包含两个元素的数组
        // intervals.add([nums[i*2], nums[i*2+1]])
        intervals.add(ArrayList<Int64>([nums[i*2], nums[i*2+1]]))
    }
    
    return intervals
}
// 手动排序实现
func sort_intervals(intervals: ArrayList<ArrayList<Int64>>) : ArrayList<ArrayList<Int64>> {
    var sorted = ArrayList<ArrayList<Int64>>()
    
    // 复制到新数组
    for (interval in intervals) {
        sorted.add(interval)
    }
    
    // 简单冒泡排序（对于最多10^4个区间可能较慢，但代码简单）
    for (i in 0..sorted.size) {
        for (j in i+1..sorted.size) {
            if(let Some(a) <- sorted.get(i)) {
                if(let Some(b) <- sorted.get(j)) {
            
                    // 如果 a[0] > b[0]，或者起点相同但 a[1] > b[1]，则交换
                    if (a[0] > b[0] || (a[0] == b[0] && a[1] > b[1])) {
                        // 交换 sorted[i] 和 sorted[j]
                        var (a1,b1) = (sorted[j][0], sorted[j][1])
                        (sorted[j][0], sorted[j][1]) = (sorted[i][0], sorted[i][1])
                        (sorted[i][0], sorted[i][1]) = (a1, b1)           // 设置另一个位置
                    }
                }
            }
        }
    }
    
    return sorted
}

// 合并区间
func merge(intervals: ArrayList<ArrayList<Int64>>) : ArrayList<ArrayList<Int64>> {
    if (intervals.size == 0) {
        return ArrayList<ArrayList<Int64>>()
    }
    
    // 排序（如果无序）
    let sorted_intervals = sort_intervals(intervals)
    // 按第一个元素排序
    
    
    // 合并逻辑
    var result = ArrayList<ArrayList<Int64>>()
    // 遍历并合并...
    var first_interval = ArrayList<Int64>()
    first_interval = sorted_intervals[0]
    if (let first_interval <- sorted_intervals[0]) {
        // 初始化当前区间
        var current_start = first_interval[0]
        var current_end = first_interval[1]

        // 从第二个区间开始遍历
        for (i in 1..sorted_intervals.size) {
            if (let Some(next_interval) <- sorted_intervals.get(i)) {
                let next_start = next_interval[0]
                let next_end = next_interval[1]
                
                // 判断是否重叠：下一个区间的起点 <= 当前区间的终点
                if (next_start <= current_end) {
                    // 有重叠，合并（取最大的终点）
                    if (next_end > current_end) {
                        current_end = next_end
                    }
                    // 继续检查下一个区间
                } else {
                    // 没有重叠，保存当前合并的区间
                    let merged_interval = ArrayList<Int64>()
                    merged_interval.add(current_start)
                    merged_interval.add(current_end)
                    result.add(merged_interval)
                    
                    // 开始新的当前区间
                    current_start = next_start
                    current_end = next_end
                }
            }
        }
        
        // 保存最后一个区间
        let last_interval = ArrayList<Int64>()
        last_interval.add(current_start)
        last_interval.add(current_end)
        result.add(last_interval)
    }
    // 当前正在合并的区间
    var current_start = first_interval[0]
    var current_end = first_interval[1]



    return result
}

// 格式化输出
func format(intervals: ArrayList<ArrayList<Int64>>) : String {
    if (intervals.size == 0) {
        return "[]"
    }
    
    var result = "["
    
    for (i in 0..intervals.size) {
        if (intervals[i].size >= 2) {
            let start = intervals[i][0]
            let end = intervals[i][1]
            
            // 添加区间字符串
            result = result + "[" + start.toString() + "," + end.toString() + "]"
            
            // 如果不是最后一个，添加逗号分隔
            if (i < intervals.size - 1) {
                result = result + ","
            }
        }
    }
    
    result = result + "]"
    return result
}

main() {
    let input = readln()
    let nums = parse_numbers(input)
    let intervals = build_intervals(nums)
    let merged_intervals = merge(intervals)
    let output = format(merged_intervals)
    println(output)
    
}