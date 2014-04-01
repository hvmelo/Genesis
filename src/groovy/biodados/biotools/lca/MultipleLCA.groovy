package biodados.biotools.lca

import biodados.biotools.taxonomy.TaxonEntry
import biodados.biotools.taxonomy.TaxonomyTree
import org.apache.log4j.Logger

import javax.swing.tree.DefaultMutableTreeNode


class MultipleLCA {

    static Logger logger = Logger.getLogger(MultipleLCA.class)


    TaxonomyTree tree
    LCA lcaFinder

    Collection<DefaultMutableTreeNode> positiveGenomeNodes
    Collection<DefaultMutableTreeNode> negativeGenomeNodes

    Collection<DefaultMutableTreeNode> excludeNodes

    DefaultMutableTreeNode lcaTreeRootNode

    Set<DefaultMutableTreeNode> nodesOnMiniLCATree

    MultipleLCA() {

        logger.info "Starting Multiple LCA instance..."

    }

    MultipleLCA(TaxonomyTree tree, LCA lcaFinder) {

        logger.info "Starting Multiple LCA instance..."

        this.tree = tree
        this.lcaFinder = lcaFinder
    }

    public Map findMultipleLCAs(List<Integer> positiveTaxIds, List<Integer> negativeTaxIds,
                                                List<Integer> excludeTaxIds = null, List<Integer> alwaysShowTaxids = null,
                                                Boolean printTree = false) {
        logger.info "Finding multiple LCAs for ${positiveTaxIds.size()} taxa..."



        logger.info "Mounting the LCA Tree..."

        lcaTreeRootNode = mountLCATree(positiveTaxIds, negativeTaxIds, excludeTaxIds)
        LCAInfo rootInfo = (LCAInfo) lcaTreeRootNode.userObject

        logger.info "LCA Tree mounted. Root node is '${rootInfo.taxonEntry.name}'."

        logger.info "Detecting multiple LCAs..."

        Set<LCAInfo> lcaSet = [] as Set

        findLCAs(lcaTreeRootNode, LCAType.NEGATIVE, lcaSet)

        logger.info "Detected ${lcaSet.size()} LCAs."

        logger.info "Mounting the Mini LCA Tree..."

        DefaultMutableTreeNode miniTreeRoot = new DefaultMutableTreeNode(lcaTreeRootNode.userObject)
        nodesOnMiniLCATree = [miniTreeRoot] as Set

        mountMiniLCATree(lcaTreeRootNode, lcaSet, miniTreeRoot, alwaysShowTaxids)

        logger.info "Adding proof nodes to the Mini LCA Tree..."

        addProofsToMiniLCATree(miniTreeRoot)

        if (printTree) {
            logger.info "Printing the Mini LCA Tree..."

            printLCAMiniTree(miniTreeRoot, lcaSet, "")
        }

        return [lcaSet: lcaSet, miniLCATree: miniTreeRoot]

    }




    private DefaultMutableTreeNode mountLCATree(Collection<Integer> positiveTaxIds, Collection<Integer> negativeTaxIds,
                                                Collection<Integer> excludeTaxIds = null) {

        logger.debug "Finding the positive LCA for ${positiveTaxIds.size()} tax ids."

        DefaultMutableTreeNode topLCA = lcaFinder.lowestCommonAncestor(positiveTaxIds, excludeTaxIds, 'node')
        TaxonEntry rootEntry = topLCA.userObject

        logger.debug "Root positive LCA is $rootEntry.name. Tax id: $rootEntry.taxId. Level: $rootEntry.level."
        logger.debug "The number of negative tax ids is ${negativeTaxIds.size()}."

        logger.debug "Finding corresponding exclude nodes on taxonomy tree..."
        excludeNodes = tree.findNodesByTaxIds(excludeTaxIds)
        Set<DefaultMutableTreeNode> excludeNodesWithChildren = [] as Set
        excludeNodesWithChildren.addAll(excludeNodes)
        excludeNodes.each { excludeNode ->
            excludeNodesWithChildren.addAll(TaxonomyTree.findAllDescendants(excludeNode, false, 'nodes'))
        }


        logger.debug "Finding corresponding positive nodes on taxonomy tree..."
        positiveGenomeNodes = tree.findNodesByTaxIds(positiveTaxIds)
        int beforeSize = positiveGenomeNodes.size()
        positiveGenomeNodes.removeAll(excludeNodesWithChildren)
        int afterSize = positiveGenomeNodes.size()
        logger.debug "Removed ${beforeSize - afterSize} unwanted nodes from positive nodes."

        logger.debug "Finding corresponding negative nodes on taxonomy tree..."
        negativeGenomeNodes = tree.findNodesByTaxIds(negativeTaxIds)
        beforeSize = negativeGenomeNodes.size()
        negativeGenomeNodes.removeAll(excludeNodesWithChildren)
        afterSize = negativeGenomeNodes.size()
        logger.debug "Removed ${beforeSize - afterSize} unwanted nodes from negative nodes."

        logger.debug "Mounting the LCA Tree..."
        return lcaTree(topLCA)

    }


    private DefaultMutableTreeNode lcaTree (DefaultMutableTreeNode taxonomyTreeNode) {



        if (taxonomyTreeNode in positiveGenomeNodes) {

            LCAInfo info = new LCAInfo(taxonEntry: taxonomyTreeNode.userObject, type: LCAType.POSITIVE_GENOME, positiveGenomeCount: 1)
            return new DefaultMutableTreeNode(info)
        }

        if (taxonomyTreeNode in negativeGenomeNodes) {
            LCAInfo info = new LCAInfo(taxonEntry: taxonomyTreeNode.userObject, type: LCAType.NEGATIVE_GENOME, negativeGenomeCount: 1)

            return new DefaultMutableTreeNode(info)

        }

        DefaultMutableTreeNode newNode = new DefaultMutableTreeNode()


        int positiveChildren = 0
        int negativeChildren = 0
        int unknownChildren = 0
        int mixedChildren = 0

        int positiveGenomeCount = 0
        int negativeGenomeCount = 0
        int unknownGenomeCount = 0

        Map<DefaultMutableTreeNode, TaxonEntry> positiveProofMap = [:]
        Map<DefaultMutableTreeNode, TaxonEntry> negativeProofMap = [:]

        Map<DefaultMutableTreeNode, Integer> positiveGenomeCountMap = [:]
        Map<DefaultMutableTreeNode, Integer> negativeGenomeCountMap = [:]

        List<DefaultMutableTreeNode> children = taxonomyTreeNode.children().toList()

        children.each {DefaultMutableTreeNode childNode ->

            DefaultMutableTreeNode newChildNode = lcaTree(childNode)

            if (newChildNode) {
                LCAInfo info = (LCAInfo) newChildNode.userObject
                switch (info.type) {
                    case LCAType.POSITIVE:
                        positiveChildren++
                        if (info.positiveProofMap && info.positiveProofMap.size() > 0) {
                            DefaultMutableTreeNode childProof = (DefaultMutableTreeNode) info.positiveProofMap.keySet().toList().first()
                            positiveProofMap.put(newChildNode, info.positiveProofMap.get(childProof))
                            positiveGenomeCountMap.put(newChildNode, info.positiveGenomeCount)
                        }
                        break
                    case LCAType.POSITIVE_GENOME:
                        positiveChildren++
                        positiveProofMap.put(newChildNode, info.taxonEntry)
                        positiveGenomeCountMap.put(newChildNode, info.positiveGenomeCount)
                        break
                    case LCAType.NEGATIVE:
                        negativeChildren++
                        if (info.negativeProofMap && info.negativeProofMap.size() > 0) {
                            DefaultMutableTreeNode childProof = (DefaultMutableTreeNode) info.negativeProofMap.keySet().toList().first()
                            negativeProofMap.put(newChildNode, info.negativeProofMap.get(childProof))
                            negativeGenomeCountMap.put(newChildNode, info.negativeGenomeCount)
                        }
                        break
                    case LCAType.NEGATIVE_GENOME:
                        negativeChildren++
                        negativeProofMap.put(newChildNode, info.taxonEntry)
                        negativeGenomeCountMap.put(newChildNode, info.negativeGenomeCount)
                        break
                    case LCAType.MIXED:
                        mixedChildren++
                        if (info.positiveProofMap && info.positiveProofMap.size() > 0) {
                            DefaultMutableTreeNode childProof = (DefaultMutableTreeNode) info.positiveProofMap.keySet().toList().first()
                            positiveProofMap.put(newChildNode, info.positiveProofMap.get(childProof))
                            positiveGenomeCountMap.put(newChildNode, info.positiveGenomeCount)
                        }
                        if (info.negativeProofMap && info.negativeProofMap.size() > 0) {
                            DefaultMutableTreeNode childProof = (DefaultMutableTreeNode) info.negativeProofMap.keySet().toList().first()
                            negativeProofMap.put(newChildNode, info.negativeProofMap.get(childProof))
                            negativeGenomeCountMap.put(newChildNode, info.negativeGenomeCount)
                        }
                }

                positiveGenomeCount += info.positiveGenomeCount
                negativeGenomeCount += info.negativeGenomeCount
                unknownGenomeCount += info.unknownGenomeCount


                newNode.add(newChildNode)
            }
            else {

                if (childNode.isLeaf()) {
                    unknownGenomeCount++
                }
                unknownChildren++
            }

        }

        //if there is only one child node, it turns into its parent


        // If there are no positive or negative nodes, returns null (node unknown)
        if (positiveChildren == 0 && negativeChildren == 0 && mixedChildren == 0) {
            return null
        }


        positiveGenomeCountMap = positiveGenomeCountMap.sort{a, b -> b.value <=> a.value}
        negativeGenomeCountMap = negativeGenomeCountMap.sort{a, b -> b.value <=> a.value}


        LCAInfo lcaInfo = new LCAInfo(taxonEntry: taxonomyTreeNode.userObject, positiveGenomeCount: positiveGenomeCount,
                                      negativeGenomeCount: negativeGenomeCount, unknownGenomeCount: unknownGenomeCount,
                                      positiveProofMap: positiveProofMap, negativeProofMap: negativeProofMap,
                                      positiveGenomeCountMap: positiveGenomeCountMap, negativeGenomeCountMap: negativeGenomeCountMap)

        newNode.userObject = lcaInfo

        if (positiveChildren > 0 && negativeChildren > 0) {

            lcaInfo.type = LCAType.MIXED

        }
        else if ((positiveChildren > 0 && mixedChildren >0) || positiveChildren > 1 || mixedChildren > 1) {

            lcaInfo.type = LCAType.POSITIVE

            //Aqui pode comparar com o numero total de folhas desconhecidas. Numero de filhos desconhecidos, tem quantas folhas?
        }
        else if ((negativeChildren > 0 && mixedChildren >0) || negativeChildren > 1 || mixedChildren > 0) {

            lcaInfo.type = LCAType.NEGATIVE

        }
        else if (newNode.childCount == 1) {
            return newNode.firstChild
        }


        return newNode

    }

    private int findNumberOfPositiveLeafs(int taxid) {

        DefaultMutableTreeNode node = tree.findNodeByTaxId(taxid)
        if (node) {
            Collection<DefaultMutableTreeNode> positiveLeaves  = positiveGenomeNodes.findAll { DefaultMutableTreeNode aNode ->
                aNode.isNodeAncestor(node)
            }
            return positiveLeaves.size()
        }

        return -1
    }


    private void findLCAs(DefaultMutableTreeNode node, LCAType parentType, Set<LCAInfo> lcaSet) {

        LCAInfo info = node.userObject as LCAInfo
        LCAType type = info.type

        boolean positiveChildWillBeLCA = false



        if (parentType == LCAType.NEGATIVE) {

            if (type == LCAType.POSITIVE) {
                logger.debug "${info.taxonEntry.name} is a LCA, since it has a negative parent."

                lcaSet << info
            }

            if (type == LCAType.MIXED) {
                positiveChildWillBeLCA = true
            }

        }

        Enumeration<DefaultMutableTreeNode> children = node.children()

        List<DefaultMutableTreeNode> viableChildren = []
        List<DefaultMutableTreeNode> negativeChildren = []


        children.each { child ->

            LCAInfo childInfo = (LCAInfo) child.userObject
            LCAType childType = childInfo.type

            if (positiveChildWillBeLCA && (childType == LCAType.POSITIVE || childType == LCAType.MIXED || childType == LCAType.POSITIVE_GENOME)) {
                viableChildren << child
            }

            if (childType == LCAType.NEGATIVE) {
                negativeChildren << child
            }

            findLCAs(child, type, lcaSet)

        }

        if (negativeChildren.size() > 1) {

            //Only consider for LCA nodes having more than one negative siblings (support)

            if (viableChildren.size() == 1) {
                LCAInfo uniqueChildInfo = (LCAInfo) viableChildren.first().userObject
                if (uniqueChildInfo.type == LCAType.POSITIVE || uniqueChildInfo.type == LCAType.POSITIVE_GENOME) {
                    logger.debug "${uniqueChildInfo.taxonEntry.name} is a LCA, since it is the unique positive child node of a mixed parent."
                    //Should also add the father to compose the tree, even though its is not a LCA

                    lcaSet << uniqueChildInfo
                }
            }
            else if (viableChildren.size() > 1) {
                logger.debug "${info.taxonEntry.name} is a LCA, since it is a mixed node with more than one viable children."

                lcaSet << info
            }
        }

    }

    void mountMiniLCATree(DefaultMutableTreeNode lcaTreeNode, Set<LCAInfo> lcaSet, DefaultMutableTreeNode miniLCAParentNode, List<Integer> alwaysShowTaxIds) {

        LCAInfo info = lcaTreeNode.userObject as LCAInfo

        List<LCAInfo> childrenInfos = lcaTreeNode?.children().toList().collect {it.userObject}

        DefaultMutableTreeNode currentMiniLCAParentNode = miniLCAParentNode

        //Verifies if it is a LCA or any of the children is a LCA
        if (lcaSet?.contains(info) || lcaSet?.intersect(childrenInfos) ||
            //lcaSet?.contains(currentMiniLCAParentNode.userObject) ||
            alwaysShowTaxIds?.contains(info.taxonEntry.taxId)) {
            if (!miniLCAParentNode.userObject.equals(info)) {
                DefaultMutableTreeNode newNode = new DefaultMutableTreeNode(info)
                miniLCAParentNode.add(newNode)
                currentMiniLCAParentNode = newNode
                nodesOnMiniLCATree << newNode
            }
        }

        Enumeration<DefaultMutableTreeNode> children = lcaTreeNode.children()

        children.each { child ->

            mountMiniLCATree(child,lcaSet,currentMiniLCAParentNode, alwaysShowTaxIds)
        }

    }

    void addProofsToMiniLCATree(DefaultMutableTreeNode miniLCATreeNode) {

        LCAInfo info = (LCAInfo) miniLCATreeNode.userObject

        Map<LCAType, List<DefaultMutableTreeNode>> childMap = miniLCATreeNode.children().toList().groupBy([{it.userObject.type}])

        Integer positiveChildrenCount = childMap.get(LCAType.POSITIVE) ? childMap.get(LCAType.POSITIVE).size() : 0
        Integer negativeChildrenCount = childMap.get(LCAType.NEGATIVE) ? childMap.get(LCAType.NEGATIVE).size() : 0
        Integer positiveGenomeChildrenCount = childMap.get(LCAType.POSITIVE_GENOME) ? childMap.get(LCAType.POSITIVE_GENOME).size() : 0
        Integer negativeGenomeChildrenCount = childMap.get(LCAType.NEGATIVE_GENOME) ? childMap.get(LCAType.NEGATIVE_GENOME).size() : 0


        if ((info.type == LCAType.POSITIVE || info.type == LCAType.MIXED) && info.positiveGenomeCountMap) {

            List<DefaultMutableTreeNode> proofs = info.positiveGenomeCountMap?.keySet().toList()
            //Remove the ones already in the tree
            List<DefaultMutableTreeNode> remainingProofs = []
            proofs.each { proofNode ->
                DefaultMutableTreeNode proofNodeOnTree = tree.findNodeByTaxId(proofNode.userObject.taxonEntry.taxId)

                DefaultMutableTreeNode node = nodesOnMiniLCATree.find { DefaultMutableTreeNode node ->
                    DefaultMutableTreeNode nodeOnTree = tree.findNodeByTaxId(node.userObject.taxonEntry.taxId)
                    nodeOnTree.isNodeAncestor(proofNodeOnTree)
                }
                if (!node) {
                    remainingProofs << proofNode
                }
            }

            int totalPositiveChildrenCount = positiveChildrenCount + positiveGenomeChildrenCount
            int totalToProof = 2 - totalPositiveChildrenCount
            if (totalToProof > 0) {
                totalToProof = Math.min(remainingProofs.size(), totalToProof)
                if (totalToProof > 0) {
                    for (int i = 0; i< totalToProof; i++) {
                        DefaultMutableTreeNode proofNode = remainingProofs.get(i)
                        TaxonEntry proofTaxonEntry = (TaxonEntry) proofNode.userObject.taxonEntry
                        LCAInfo proofLCAInfo = new LCAInfo(type: proofNode.userObject.type, taxonEntry: proofTaxonEntry, negativeGenomeCount: proofNode.userObject.negativeGenomeCount,
                            positiveGenomeCount: proofNode.userObject.positiveGenomeCount, unknownGenomeCount: proofNode.userObject.unknownGenomeCount)
                        DefaultMutableTreeNode proofMiniNode = new DefaultMutableTreeNode(proofLCAInfo)
                        if (proofNode.userObject.type != LCAType.POSITIVE_GENOME) {
                            TaxonEntry leafTaxonEntry = info.positiveProofMap.get(proofNode)
                            LCAInfo leafLCAInfo = new LCAInfo(type: LCAType.POSITIVE_GENOME, taxonEntry: leafTaxonEntry, positiveGenomeCount: 1)
                            miniLCATreeNode.add(new DefaultMutableTreeNode(leafLCAInfo))
                        }
                        else {
                            miniLCATreeNode.add(proofMiniNode)

                        }
                    }
                }
            }
        }
        if ((info.type == LCAType.NEGATIVE || info.type == LCAType.MIXED) && info.negativeGenomeCountMap) {

            List<DefaultMutableTreeNode> proofs = info.negativeGenomeCountMap.keySet().toList()
            //Remove the ones already in the tree
            List<DefaultMutableTreeNode> remainingProofs = []
            proofs.each { proofNode ->
                DefaultMutableTreeNode proofNodeOnTree = tree.findNodeByTaxId(proofNode.userObject.taxonEntry.taxId)

                DefaultMutableTreeNode node = nodesOnMiniLCATree.find { DefaultMutableTreeNode node ->
                    DefaultMutableTreeNode nodeOnTree = tree.findNodeByTaxId(node.userObject.taxonEntry.taxId)
                    nodeOnTree.isNodeAncestor(proofNodeOnTree)
                }
                if (!node) {
                    remainingProofs << proofNode
                }
            }
            int totalNegativeChildrenCount = negativeChildrenCount + negativeGenomeChildrenCount
            int totalToProof = 2 - totalNegativeChildrenCount
            if (totalToProof > 0) {
                totalToProof = Math.min(remainingProofs.size(), totalToProof)
                if (totalToProof > 0) {
                    for (int i = 0; i< totalToProof; i++) {
                        DefaultMutableTreeNode proofNode = remainingProofs.get(i)
                        TaxonEntry proofTaxonEntry = (TaxonEntry) proofNode.userObject.taxonEntry
                        LCAInfo proofLCAInfo = new LCAInfo(type: proofNode.userObject.type, taxonEntry: proofTaxonEntry, negativeGenomeCount: proofNode.userObject.negativeGenomeCount,
                                                           positiveGenomeCount: proofNode.userObject.positiveGenomeCount, unknownGenomeCount: proofNode.userObject.unknownGenomeCount)
                        DefaultMutableTreeNode proofMiniNode = new DefaultMutableTreeNode(proofLCAInfo)
                        if (proofNode.userObject.type != LCAType.NEGATIVE_GENOME) {
                            TaxonEntry leafTaxonEntry = info.negativeProofMap.get(proofNode)
                            LCAInfo leafLCAInfo = new LCAInfo(type: LCAType.NEGATIVE_GENOME, taxonEntry: leafTaxonEntry, negativeGenomeCount: 1)
                            miniLCATreeNode.add(new DefaultMutableTreeNode(leafLCAInfo))
                        }
                        else {
                            miniLCATreeNode.add(proofMiniNode)

                        }
                    }
                }
            }
        }

        //Add proofs to the children nodes
        miniLCATreeNode.children().each { DefaultMutableTreeNode childNode ->
            addProofsToMiniLCATree(childNode)
        }

    }



    void printLCAMiniTree(DefaultMutableTreeNode lcaMiniTreeNode, Set<LCAInfo> lcaSet, String space) {


        LCAInfo info = (LCAInfo) lcaMiniTreeNode.userObject

        String symbol = ""
        String compl = ""

        switch (info.type) {
            case LCAType.POSITIVE:
                compl = "(txid:${info.taxonEntry.taxId} P:${info.positiveGenomeCount} N:${info.negativeGenomeCount})"
                symbol += "+"
                break
            case LCAType.POSITIVE_GENOME:
                compl = "(txid:${info.taxonEntry.taxId})"
                symbol += "+"
                break
            case LCAType.NEGATIVE:
                compl = "(txid:${info.taxonEntry.taxId} P:${info.positiveGenomeCount} N:${info.negativeGenomeCount})"
                symbol += "o"
                break
            case LCAType.NEGATIVE_GENOME:
                compl = "(txid:${info.taxonEntry.taxId})"
                symbol += "o"
                break
            case LCAType.MIXED:
                symbol += "*"
                compl = "(txid:${info.taxonEntry.taxId} P:${info.positiveGenomeCount} N:${info.negativeGenomeCount})"
                break
        }

        if (lcaSet.contains(info)) {
            symbol += " (LCA)"
        }

        println "$symbol $info.taxonEntry.name $compl"


        lcaMiniTreeNode.children().each {DefaultMutableTreeNode child ->

            LCAInfo childInfo = (LCAInfo) child.userObject
            int levelDiff = childInfo.taxonEntry.level - info.taxonEntry.level

            StringBuffer traces = new StringBuffer()
            StringBuffer spaces = new StringBuffer()

            println space +  "|"
            for (int i = 0; i < levelDiff; i++) {
                traces.append("-")
                spaces.append(" ")
            }
            print space + "|---" + traces.toString() + " "
            printLCAMiniTree(child, lcaSet, space + "|   " + spaces.toString())

        }




    }






}


