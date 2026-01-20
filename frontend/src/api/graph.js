import axios from 'axios'

const API_BASE_URL = '/api'

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json'
  }
})

export const graphApi = {
  // Get graph data
  getGraphData(entityIds = null, timePoint = null) {
    const params = {}
    if (entityIds) params.entityIds = entityIds
    if (timePoint) params.timePoint = timePoint
    return api.get('/graph/data', { params })
  },

  // Peripheral search
  peripheralSearch(data) {
    return api.post('/graph/peripheral-search', data)
  },

  // Get relation types for ontology type
  getRelationTypes(ontologyTypeId) {
    return api.get(`/graph/relation-types/${ontologyTypeId}`)
  },

  // Get actions for ontology type
  getActions(ontologyTypeId) {
    return api.get(`/graph/actions/${ontologyTypeId}`)
  },

  // Create entity
  createEntity(data) {
    return api.post('/graph/entity', data)
  },

  // Get entities by type
  getEntitiesByType(ontologyTypeId) {
    return api.get(`/graph/entities/${ontologyTypeId}`)
  },

  // Get entity by id
  getEntityById(entityId) {
    return api.get(`/graph/entity/${entityId}`)
  }
}

export const ontologyApi = {
  // Get all ontology types
  getAllOntologyTypes() {
    return api.get('/ontology/types')
  },

  // Get ontology type by id
  getOntologyTypeById(id) {
    return api.get(`/ontology/types/${id}`)
  },

  // Create ontology type
  createOntologyType(data) {
    return api.post('/ontology/types', data)
  }
}

export default api
