class BootStrap {

    def taxonomyTree
    def taxonomyDao
    def sessionFactory

    def init = { servletContext ->

        if (!taxonomyTree.rootNode) {
            taxonomyDao.sessionFactory = sessionFactory
            taxonomyDao.init()
            taxonomyTree.mountTaxonomyTree()
        }


    }
    def destroy = {
    }
}
