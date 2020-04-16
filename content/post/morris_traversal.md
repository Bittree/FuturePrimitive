---
title: "Morris遍历"
date: 2020-04-16T18:31:00+08:00
---

二叉树的遍历大家都很熟悉了，一般是递归和迭代两种方法，区别是递归是把有效状态保存在语言的栈中，迭代是有效状态保存在堆上(容器栈或者是队列)。

非递归的空间复杂度更高，也就是需要更多的内存，代码也更多，不过可以避免树的深度比较大时递归可能会出现的栈溢出的问题。

但是迭代的方法在中序和后序遍历的时候都需要标记当前节点的子节点的访问情况，主要的方式有：

1. 节点中就包含字段标识左孩子/右孩子是否访问过，如果访问过则访问当前节点之后退出；
2. 把当前节点的孩子放入访问的序列容器之后，就从当前节点中删除指向该子节点的指针。

但是这两种方式一种是对节点的结构有要求，一种是在运行时破坏了树的结构，都不是完美的解决方案。有没有完美的解决方案呢？

当然有，这就是[Morris遍历](https://en.wikipedia.org/wiki/Threaded_binary_tree),在这篇[介绍](https://zhuanlan.zhihu.com/p/101321696)中描述它是二叉树遍历的“神级”
方法。

主要优点：
1. 空间复杂度从O(N)降到了O(1)
2. 时间复杂度不变，还是O(N)
3. 遍历后树的结构不被破坏

    要使用O(1)空间进行遍历，最大的难点在于，遍历到子节点的时候怎样重新返回到父节点（假设节点中没有指向父节点的p指针），由于不能用栈作为辅助空间。为了解决这个问题，Morris方法用到了线索二叉树（threaded binary tree）的概念。在Morris方法中不需要为每个节点额外分配指针指向其前驱（predecessor）和后继节点（successor），只需要利用叶子节点中的左右空指针指向某种顺序遍历下的前驱节点或后继节点就可以了。

Morris遍历主要面向中序遍历，不过修改之后可以用作前序遍历和后序遍历。

```
// 中序遍历 golang版本
func InorderTraversal(root *TreeNode) {
    cur := root
    var prev *TreeNode
    for cur != nil {
        if cur.Left == nil {
            fmt.Println(cur.Val) // 如果当前节点的左孩子为空，就访问当前节点并把当前节点设置为右孩子
            cur = cur.Right
        }else{
            // 如果当前节点有左孩子，就从当前节点左孩子开始，不断往下找到最右边的右孩子，就是当前节点的前驱节点，这是二叉树中序遍历的特点
            prev = cur.Left
            for prev.Right != nil && prev.Right != cur {
                prev = prev.Right
            }

            if prev.Right == nil { // 第一次找到的前驱节点右孩子应该为空，这时候让它指向当前节点
                prev.Right = cur
                cur = cur.Left
            }else{
                // 如果不为空的话，说明之前已经建立过前驱节点到当前节点的连接了，这时应该访问当前节点，并取消前驱节点到当前节点的指向
                prev.Right = nil
                fmt.Println(cur.Val)
                cur = cur.Right // 因为左孩子和当前节点都已经访问过了，所以按照顺序要跳到当前节点的右节点
            }
        }
    }
}
```

实际上这里就是利用中序遍历的性质，某一个节点的前驱节点的右孩子一定为空，那么让它暂时指向当前节点，这样可以利用“某一个节点的前驱节点的右孩子是否为空”这个条件来判断“当前节点的左子树是否已经遍历过”，如果已经遍历过就把前驱节点的右孩子指向重新置为空，这样就恢复了树本来的形状了。也就是一个节点要找两次前驱节点，第一次用来建立到当前节点的连接，第二次用来确认是否当前节点的左子树遍历过。

因为整个算法充分利用了树上的空间，所以用到的额外空间只有cur和prev两个节点指针，空间复杂度是O(1).而二叉树中如果有n个节点，n-1条边，每条边找前驱节点走了两次，当前节点跳转走了一次，一共走了3次。所以时间复杂度为O(n).

### 前序遍历

要改成前序遍历，初步考虑下应该让当前节点前驱结点的左孩子指向它的右孩子，因为在前序遍历中，当前节点的左孩子的后继节点是它的右节点。但这样做会有两个问题：
1. 如果让左孩子直接指向右孩子的话，右孩子有可能为空，这样就没法区分左子树是否访问过了；
2. 如果右孩子不为空，直接从左孩子跳到右孩子后，当前节点就变成右孩子了，那之前的这个节点的左孩子到右孩子的指向就会没法重置为空，因为没法再从右孩子回到当前节点，就会导致树的结构没法恢复。

所以这里还是要让前驱节点指向当前节点，再由当前节点找到右孩子。

```
// 前序遍历 golang版本
func PreorderTraversal(root *TreeNode) {
    cur := root
    var prev *TreeNode
    for cur != nil {
        if cur.Left == nil {
            fmt.Println(cur.Val) // 如果当前节点的左孩子为空，就访问当前节点并把当前节点设置为右孩子
            cur = cur.Right
        }else{
            // 如果当前节点有左孩子，就从当前节点左孩子开始，不断往下找到最右边的右孩子，就是当前节点的右孩子的前驱节点，这是二叉树前序遍历的特点
            prev = cur.Left
            for prev.Right != nil && prev.Right != cur {
                prev = prev.Right
            }

            if prev.Right == nil { // 第一次找到的前驱节点右孩子应该为空，这时候让它指向当前节点，因为这是第一次找到前驱，按照前序遍历的顺序应该先访问当前节点
                fmt.Println(cur.Val)
                prev.Right = cur
                cur = cur.Left
            }else{
                // 如果不为空的话，说明之前已经建立过前驱节点到当前节点的连接了，这时应该取消前驱节点到当前节点的指向
                prev.Right = nil
                cur = cur.Right // 因为左孩子和当前节点都已经访问过了，所以按照顺序要跳到当前节点的右节点
            }
        }
    }
}
```

## 后序遍历

后序遍历比较麻烦，因为需要在访问左右子树之后再访问根节点，但是用之前前驱节点到当前节点的连接，没办法在访问右子树之后再回到根节点去访问。

不过，既然没办法从右子树回到根节点去访问，我们不如让根节点成为另一个节点的左孩子，这样它就能被访问到了。我们创建一个临时的节点，让根节点作为它的左孩子。

```
// 后序遍历 golang版本
void reverse(from *TreeNode, to *TreeNode) {
    if from == to {
        return
    }
    prev := from
    cur := from.Right
    for {
        next := cur.Right
        cur.Right = prev
        prev = cur
        cur = next
        if prev == to {
            break
        }
    }
}

void reverseAccess(from *TreeNode, to *TreeNode) {
    // 可以考虑先存到栈里再访问，不过这样空间复杂度是O(n)了，可以先把链表反向之后再反回来
    reverse(from, to)

    // 访问节点，从to到from
    cur := to
    for {
        fmt.Println(cur.Val)
        if cur == from {
            break
        }
        cur = cur.Right
    }

    reverse(to, from)
}

void PostorderTraversal(root *TreeNode) {
    temp := &TreeNode{Left: root}
    cur := temp
    var prev *TreeNode
    if cur != nil {
        if cur.Left == nil {
            cur = cur.Right
        }else{
            prev = cur.Left
            for prev.Right != nil && prev.Right != cur {
                prev = prev.Right
            }
            if prev.Right == nil {
                prev.Right = cur
                cur = cur.Left
            }else{
                // 倒序访问当前节点的左孩子到当前节点的前驱节点的路径上的所有节点,相当于倒序输出链表
                reverseAccess(cur.Left, prev)

                prev.Right = nil
                cur = cur.Right
            }
        }
    }
}
```

这样处理之后空间复杂度还是O(1),倒序输出增加了时间，不过也是常数倍数，时间复杂度仍是O(n)

参考资料：https://www.cnblogs.com/anniekim/archive/2013/06/15/morristraversal.html