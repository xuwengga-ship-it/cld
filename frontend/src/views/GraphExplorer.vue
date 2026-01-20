<template>
  <div class="graph-explorer">
    <!-- Header -->
    <div class="header">
      <div class="header-left">
        <el-icon><Grid /></el-icon>
        <span class="title">本体管理</span>
      </div>
      <div class="header-right">
        <el-dropdown>
          <span class="user-info">
            <el-avatar :size="32">User</el-avatar>
            <span>欢迎您，访问用户</span>
          </span>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item>个人设置</el-dropdown-item>
              <el-dropdown-item>退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </div>

    <div class="main-content">
      <!-- Sidebar -->
      <div class="sidebar">
        <div class="menu-item">
          <el-icon><Book /></el-icon>
          <span>课本</span>
        </div>
        <div class="menu-item">
          <el-icon><Calendar /></el-icon>
          <span>单位</span>
        </div>
        <div class="menu-item">
          <el-icon><User /></el-icon>
          <span>主次关系新</span>
        </div>
        <div class="menu-item active">
          <el-icon><Connection /></el-icon>
          <span>对象类型</span>
        </div>
        <div class="menu-item">
          <el-icon><Collection /></el-icon>
          <span>属性</span>
        </div>
        <div class="menu-item">
          <el-icon><TrendCharts /></el-icon>
          <span>属性类型</span>
        </div>
        <div class="menu-item">
          <el-icon><Link /></el-icon>
          <span>链接</span>
        </div>
        <div class="menu-item">
          <el-icon><Box /></el-icon>
          <span>分组</span>
        </div>
        <div class="menu-item">
          <el-icon><Files /></el-icon>
          <span>接口</span>
        </div>
        <div class="menu-item">
          <el-icon><Document /></el-icon>
          <span>值类型</span>
        </div>
        <div class="menu-item">
          <el-icon><Setting /></el-icon>
          <span>健康问题</span>
        </div>
        <div class="menu-item">
          <el-icon><DataAnalysis /></el-icon>
          <span>清理</span>
        </div>
      </div>

      <!-- Left Panel -->
      <div class="left-panel" v-if="selectedEntity">
        <div class="entity-info">
          <div class="entity-header">
            <el-icon><OfficeBuilding /></el-icon>
            <h3>{{ selectedEntity.name }}</h3>
          </div>
          <div class="entity-type">{{ selectedEntity.ontologyType?.name || '未知类型' }}</div>
          <div class="entity-details">
            <div class="detail-section">
              <h4>基本信息</h4>
              <div class="detail-item" v-for="(value, key) in selectedEntityProperties" :key="key">
                <span class="detail-label">{{ key }}:</span>
                <span class="detail-value">{{ value }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Graph Canvas -->
      <div class="graph-container">
        <!-- Toolbar -->
        <div class="toolbar">
          <el-button-group>
            <el-tooltip content="新增对象">
              <el-button @click="showAddEntityDialog" :icon="Plus">新增对象</el-button>
            </el-tooltip>
            <el-tooltip content="周边搜索">
              <el-button @click="showPeripheralSearchDialog" :icon="Search" :disabled="selectedNodes.length === 0">
                周边搜索
              </el-button>
            </el-tooltip>
            <el-tooltip content="动作">
              <el-button @click="showActionsDialog" :icon="Lightning" :disabled="selectedNodes.length === 0">
                动作
              </el-button>
            </el-tooltip>
            <el-tooltip content="自动布局">
              <el-button @click="autoLayout" :icon="Grid">自动布局</el-button>
            </el-tooltip>
            <el-tooltip content="适应画布">
              <el-button @click="fitToContent" :icon="FullScreen">适应画布</el-button>
            </el-tooltip>
            <el-tooltip content="缩放">
              <el-button @click="zoomIn" :icon="ZoomIn"></el-button>
            </el-tooltip>
            <el-tooltip content="缩小">
              <el-button @click="zoomOut" :icon="ZoomOut"></el-button>
            </el-tooltip>
          </el-button-group>
        </div>

        <!-- X6 Graph Canvas -->
        <div ref="graphCanvas" class="graph-canvas"></div>

        <!-- Timeline -->
        <div class="timeline-container">
          <div class="timeline-controls">
            <el-icon><Clock /></el-icon>
            <span class="timeline-label">时间轴:</span>
            <el-radio-group v-model="timeRange" size="small" @change="onTimeRangeChange">
              <el-radio-button label="today">当天</el-radio-button>
              <el-radio-button label="month">一月</el-radio-button>
              <el-radio-button label="year">半年</el-radio-button>
              <el-radio-button label="all">一年</el-radio-button>
            </el-radio-group>
          </div>
          <div class="timeline-slider">
            <el-slider
              v-model="timelineValue"
              :marks="timelineMarks"
              @change="onTimelineChange"
              :show-tooltip="true"
              :format-tooltip="formatTimeTooltip"
            />
          </div>
        </div>
      </div>
    </div>

    <!-- Peripheral Search Dialog -->
    <el-dialog
      v-model="peripheralSearchVisible"
      title="周边搜索"
      width="500px"
    >
      <el-form :model="peripheralSearchForm" label-width="100px">
        <el-form-item label="关系类型">
          <el-checkbox-group v-model="peripheralSearchForm.relationTypeIds">
            <el-checkbox
              v-for="relType in availableRelationTypes"
              :key="relType.id"
              :label="relType.id"
            >
              {{ relType.name }}
            </el-checkbox>
          </el-checkbox-group>
        </el-form-item>
        <el-form-item label="搜索深度">
          <el-input-number
            v-model="peripheralSearchForm.depth"
            :min="1"
            :max="5"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="peripheralSearchVisible = false">取消</el-button>
        <el-button type="primary" @click="executePeripheralSearch">搜索</el-button>
      </template>
    </el-dialog>

    <!-- Actions Dialog -->
    <el-dialog
      v-model="actionsVisible"
      title="对象动作"
      width="400px"
    >
      <el-menu>
        <el-menu-item
          v-for="action in availableActions"
          :key="action.id"
          @click="executeAction(action)"
        >
          <el-icon><component :is="action.icon || 'Menu'" /></el-icon>
          <span>{{ action.name }}</span>
        </el-menu-item>
      </el-menu>
    </el-dialog>

    <!-- Add Entity Dialog -->
    <el-dialog
      v-model="addEntityVisible"
      title="新增对象"
      width="600px"
    >
      <el-form :model="addEntityForm" label-width="100px">
        <el-form-item label="对象类型">
          <el-select v-model="addEntityForm.ontologyTypeId" placeholder="请选择对象类型" @change="onOntologyTypeChange">
            <el-option
              v-for="type in ontologyTypes"
              :key="type.id"
              :label="type.name"
              :value="type.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="对象实例">
          <el-select
            v-model="addEntityForm.selectedEntityIds"
            multiple
            placeholder="请选择对象实例"
            style="width: 100%"
          >
            <el-option
              v-for="entity in availableEntities"
              :key="entity.id"
              :label="entity.name"
              :value="entity.id"
            />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="addEntityVisible = false">取消</el-button>
        <el-button type="primary" @click="addEntitiesToGraph">添加到画布</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, onMounted, reactive } from 'vue'
import { Graph } from '@antv/x6'
import { DagreLayout } from '@antv/layout'
import { graphApi, ontologyApi } from '@/api/graph'
import {
  Grid, Book, Calendar, User, Connection, Collection, TrendCharts,
  Link, Box, Files, Document, Setting, DataAnalysis, OfficeBuilding,
  Plus, Search, Lightning, FullScreen, ZoomIn, ZoomOut, Clock
} from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'

export default {
  name: 'GraphExplorer',
  components: {
    Grid, Book, Calendar, User, Connection, Collection, TrendCharts,
    Link, Box, Files, Document, Setting, DataAnalysis, OfficeBuilding,
    Plus, Search, Lightning, FullScreen, ZoomIn, ZoomOut, Clock
  },
  setup() {
    const graphCanvas = ref(null)
    let graph = null

    // State
    const selectedEntity = ref(null)
    const selectedEntityProperties = ref({})
    const selectedNodes = ref([])
    const ontologyTypes = ref([])
    const timeRange = ref('all')
    const timelineValue = ref(100)
    const timelineMarks = ref({
      0: '内部1',
      20: '内部2',
      40: '内部3',
      60: '内部4',
      80: '内部5',
      100: '内部6'
    })

    // Dialogs
    const peripheralSearchVisible = ref(false)
    const actionsVisible = ref(false)
    const addEntityVisible = ref(false)

    // Forms
    const peripheralSearchForm = reactive({
      relationTypeIds: [],
      depth: 1
    })
    const addEntityForm = reactive({
      ontologyTypeId: null,
      selectedEntityIds: []
    })

    // Available data
    const availableRelationTypes = ref([])
    const availableActions = ref([])
    const availableEntities = ref([])

    // Initialize X6 Graph
    const initGraph = () => {
      graph = new Graph({
        container: graphCanvas.value,
        autoResize: true,
        panning: {
          enabled: true,
          modifiers: 'shift'
        },
        mousewheel: {
          enabled: true,
          modifiers: 'ctrl',
          minScale: 0.2,
          maxScale: 4
        },
        selecting: {
          enabled: true,
          multiple: true,
          rubberband: true,
          movable: true,
          showNodeSelectionBox: true
        },
        connecting: {
          snap: true,
          allowBlank: false,
          highlight: true
        },
        highlighting: {
          magnetAvailable: {
            name: 'stroke',
            args: {
              padding: 4,
              attrs: {
                strokeWidth: 4,
                stroke: '#6a6c8a'
              }
            }
          }
        }
      })

      // Register node and edge events
      graph.on('node:click', ({ node }) => {
        handleNodeClick(node)
      })

      graph.on('selection:changed', ({ selected }) => {
        selectedNodes.value = selected.map(cell => cell.id)
      })

      // Load initial graph data
      loadGraphData()
    }

    // Load graph data
    const loadGraphData = async (entityIds = null, timePoint = null) => {
      try {
        const response = await graphApi.getGraphData(entityIds, timePoint)
        const { nodes, edges } = response.data

        // Clear existing graph
        graph.clearCells()

        // Add nodes
        nodes.forEach(node => {
          graph.addNode({
            id: node.id,
            x: node.x || Math.random() * 800,
            y: node.y || Math.random() * 600,
            width: 180,
            height: 60,
            shape: 'rect',
            attrs: {
              body: {
                fill: node.color || '#1890FF',
                stroke: '#0050B3',
                strokeWidth: 2,
                rx: 6,
                ry: 6
              },
              label: {
                text: node.label,
                fill: '#fff',
                fontSize: 14,
                textWrap: {
                  width: 170,
                  height: 50,
                  ellipsis: true
                }
              }
            },
            data: node
          })
        })

        // Add edges
        edges.forEach(edge => {
          graph.addEdge({
            id: edge.id,
            source: edge.source,
            target: edge.target,
            attrs: {
              line: {
                stroke: edge.color || '#A0A0A0',
                strokeWidth: 2,
                targetMarker: {
                  name: 'block',
                  width: 12,
                  height: 8
                }
              }
            },
            labels: [{
              attrs: {
                label: {
                  text: edge.label,
                  fill: '#666',
                  fontSize: 12
                },
                body: {
                  fill: '#fff',
                  stroke: '#ccc',
                  strokeWidth: 1,
                  rx: 4,
                  ry: 4
                }
              }
            }],
            data: edge
          })
        })

        // Auto layout
        autoLayout()
      } catch (error) {
        console.error('Failed to load graph data:', error)
        ElMessage.error('加载图谱数据失败')
      }
    }

    // Handle node click
    const handleNodeClick = async (node) => {
      const nodeData = node.getData()
      const entityId = nodeData.id.replace('entity_', '')

      try {
        const response = await graphApi.getEntityById(entityId)
        selectedEntity.value = response.data

        // Parse properties
        if (response.data.properties) {
          selectedEntityProperties.value = JSON.parse(response.data.properties)
        }
      } catch (error) {
        console.error('Failed to load entity details:', error)
      }
    }

    // Auto layout
    const autoLayout = () => {
      const nodes = graph.getNodes()
      const edges = graph.getEdges()

      const dagreLayout = new DagreLayout({
        type: 'dagre',
        rankdir: 'LR',
        nodesep: 50,
        ranksep: 100,
        controlPoints: true
      })

      const model = {
        nodes: nodes.map(node => ({
          id: node.id,
          width: node.size().width,
          height: node.size().height
        })),
        edges: edges.map(edge => ({
          source: edge.getSourceCellId(),
          target: edge.getTargetCellId()
        }))
      }

      const newModel = dagreLayout.layout(model)

      newModel.nodes.forEach(node => {
        const cell = graph.getCellById(node.id)
        if (cell) {
          cell.position(node.x, node.y)
        }
      })
    }

    // Fit to content
    const fitToContent = () => {
      graph.zoomToFit({ padding: 50, maxScale: 1 })
    }

    // Zoom in/out
    const zoomIn = () => {
      graph.zoom(0.2)
    }

    const zoomOut = () => {
      graph.zoom(-0.2)
    }

    // Show peripheral search dialog
    const showPeripheralSearchDialog = async () => {
      if (selectedNodes.value.length === 0) {
        ElMessage.warning('请先选择节点')
        return
      }

      // Get first selected node's ontology type
      const firstNode = graph.getCellById(selectedNodes.value[0])
      const nodeData = firstNode.getData()
      const ontologyTypeId = nodeData.ontologyTypeId

      try {
        const response = await graphApi.getRelationTypes(ontologyTypeId)
        availableRelationTypes.value = response.data
        peripheralSearchVisible.value = true
      } catch (error) {
        console.error('Failed to load relation types:', error)
        ElMessage.error('加载关系类型失败')
      }
    }

    // Execute peripheral search
    const executePeripheralSearch = async () => {
      const entityIds = selectedNodes.value.map(id => {
        return parseInt(id.replace('entity_', ''))
      })

      try {
        const response = await graphApi.peripheralSearch({
          entityIds,
          relationTypeIds: peripheralSearchForm.relationTypeIds.length > 0 ? peripheralSearchForm.relationTypeIds : null,
          depth: peripheralSearchForm.depth,
          timePoint: getCurrentTimePoint()
        })

        const { nodes, edges } = response.data

        // Add new nodes and edges to graph
        nodes.forEach(node => {
          if (!graph.getCellById(node.id)) {
            graph.addNode({
              id: node.id,
              x: Math.random() * 800,
              y: Math.random() * 600,
              width: 180,
              height: 60,
              shape: 'rect',
              attrs: {
                body: {
                  fill: node.color || '#1890FF',
                  stroke: '#0050B3',
                  strokeWidth: 2,
                  rx: 6,
                  ry: 6
                },
                label: {
                  text: node.label,
                  fill: '#fff',
                  fontSize: 14
                }
              },
              data: node
            })
          }
        })

        edges.forEach(edge => {
          if (!graph.getCellById(edge.id)) {
            graph.addEdge({
              id: edge.id,
              source: edge.source,
              target: edge.target,
              attrs: {
                line: {
                  stroke: edge.color || '#A0A0A0',
                  strokeWidth: 2,
                  targetMarker: {
                    name: 'block',
                    width: 12,
                    height: 8
                  }
                }
              },
              labels: [{
                attrs: {
                  label: {
                    text: edge.label,
                    fill: '#666',
                    fontSize: 12
                  }
                }
              }],
              data: edge
            })
          }
        })

        autoLayout()
        peripheralSearchVisible.value = false
        ElMessage.success('周边搜索完成')
      } catch (error) {
        console.error('Peripheral search failed:', error)
        ElMessage.error('周边搜索失败')
      }
    }

    // Show actions dialog
    const showActionsDialog = async () => {
      if (selectedNodes.value.length === 0) {
        ElMessage.warning('请先选择节点')
        return
      }

      const firstNode = graph.getCellById(selectedNodes.value[0])
      const nodeData = firstNode.getData()
      const ontologyTypeId = nodeData.ontologyTypeId

      try {
        const response = await graphApi.getActions(ontologyTypeId)
        availableActions.value = response.data
        actionsVisible.value = true
      } catch (error) {
        console.error('Failed to load actions:', error)
        ElMessage.error('加载动作失败')
      }
    }

    // Execute action
    const executeAction = (action) => {
      ElMessage.info(`执行动作: ${action.name}`)
      actionsVisible.value = false
    }

    // Show add entity dialog
    const showAddEntityDialog = async () => {
      try {
        const response = await ontologyApi.getAllOntologyTypes()
        ontologyTypes.value = response.data
        addEntityVisible.value = true
      } catch (error) {
        console.error('Failed to load ontology types:', error)
        ElMessage.error('加载本体类型失败')
      }
    }

    // On ontology type change
    const onOntologyTypeChange = async (typeId) => {
      try {
        const response = await graphApi.getEntitiesByType(typeId)
        availableEntities.value = response.data
      } catch (error) {
        console.error('Failed to load entities:', error)
        ElMessage.error('加载实体失败')
      }
    }

    // Add entities to graph
    const addEntitiesToGraph = async () => {
      if (addEntityForm.selectedEntityIds.length === 0) {
        ElMessage.warning('请选择至少一个对象实例')
        return
      }

      try {
        const response = await graphApi.getGraphData(addEntityForm.selectedEntityIds, getCurrentTimePoint())
        const { nodes, edges } = response.data

        // Add nodes to graph
        nodes.forEach(node => {
          if (!graph.getCellById(node.id)) {
            graph.addNode({
              id: node.id,
              x: Math.random() * 800,
              y: Math.random() * 600,
              width: 180,
              height: 60,
              shape: 'rect',
              attrs: {
                body: {
                  fill: node.color || '#1890FF',
                  stroke: '#0050B3',
                  strokeWidth: 2,
                  rx: 6,
                  ry: 6
                },
                label: {
                  text: node.label,
                  fill: '#fff',
                  fontSize: 14
                }
              },
              data: node
            })
          }
        })

        edges.forEach(edge => {
          if (!graph.getCellById(edge.id)) {
            graph.addEdge({
              id: edge.id,
              source: edge.source,
              target: edge.target,
              attrs: {
                line: {
                  stroke: edge.color || '#A0A0A0',
                  strokeWidth: 2,
                  targetMarker: {
                    name: 'block',
                    width: 12,
                    height: 8
                  }
                }
              },
              labels: [{
                attrs: {
                  label: {
                    text: edge.label,
                    fill: '#666',
                    fontSize: 12
                  }
                }
              }],
              data: edge
            })
          }
        })

        autoLayout()
        addEntityVisible.value = false
        addEntityForm.selectedEntityIds = []
        ElMessage.success('添加对象成功')
      } catch (error) {
        console.error('Failed to add entities:', error)
        ElMessage.error('添加对象失败')
      }
    }

    // Timeline functions
    const onTimeRangeChange = (value) => {
      loadGraphData(null, getCurrentTimePoint())
    }

    const onTimelineChange = (value) => {
      loadGraphData(null, getCurrentTimePoint())
    }

    const formatTimeTooltip = (value) => {
      return timelineMarks.value[value] || `${value}%`
    }

    const getCurrentTimePoint = () => {
      // Calculate time point based on timeline value
      // For now, return null to get all data
      return null
    }

    onMounted(() => {
      initGraph()
    })

    return {
      graphCanvas,
      selectedEntity,
      selectedEntityProperties,
      selectedNodes,
      ontologyTypes,
      timeRange,
      timelineValue,
      timelineMarks,
      peripheralSearchVisible,
      actionsVisible,
      addEntityVisible,
      peripheralSearchForm,
      addEntityForm,
      availableRelationTypes,
      availableActions,
      availableEntities,
      autoLayout,
      fitToContent,
      zoomIn,
      zoomOut,
      showPeripheralSearchDialog,
      executePeripheralSearch,
      showActionsDialog,
      executeAction,
      showAddEntityDialog,
      onOntologyTypeChange,
      addEntitiesToGraph,
      onTimeRangeChange,
      onTimelineChange,
      formatTimeTooltip
    }
  }
}
</script>

<style scoped>
.graph-explorer {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background-color: #f0f2f5;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 60px;
  padding: 0 24px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 20px;
  font-weight: 600;
}

.header-right .user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}

.main-content {
  display: flex;
  flex: 1;
  overflow: hidden;
}

.sidebar {
  width: 140px;
  background-color: white;
  border-right: 1px solid #e8e8e8;
  overflow-y: auto;
  padding: 8px 0;
}

.menu-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 12px;
  cursor: pointer;
  font-size: 12px;
  color: #666;
  transition: all 0.3s;
}

.menu-item:hover {
  background-color: #f5f5f5;
}

.menu-item.active {
  background-color: #e6f7ff;
  color: #1890ff;
}

.left-panel {
  width: 360px;
  background-color: white;
  border-right: 1px solid #e8e8e8;
  overflow-y: auto;
  padding: 16px;
}

.entity-info {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.entity-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 18px;
  font-weight: 600;
  color: #1890ff;
}

.entity-type {
  padding: 4px 12px;
  background-color: #f0f0f0;
  border-radius: 4px;
  font-size: 12px;
  color: #666;
  display: inline-block;
  width: fit-content;
}

.entity-details {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.detail-section h4 {
  margin-bottom: 8px;
  color: #333;
  font-size: 14px;
}

.detail-item {
  display: flex;
  padding: 8px 0;
  border-bottom: 1px solid #f0f0f0;
  font-size: 13px;
}

.detail-label {
  flex: 0 0 120px;
  color: #999;
}

.detail-value {
  flex: 1;
  color: #333;
}

.graph-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  background-color: white;
  position: relative;
}

.toolbar {
  padding: 12px 16px;
  border-bottom: 1px solid #e8e8e8;
  background-color: #fafafa;
}

.graph-canvas {
  flex: 1;
  background-color: #fafbfc;
  background-image:
    linear-gradient(#e8e8e8 1px, transparent 1px),
    linear-gradient(90deg, #e8e8e8 1px, transparent 1px);
  background-size: 20px 20px;
}

.timeline-container {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  width: 80%;
  max-width: 1200px;
  background-color: white;
  border-radius: 8px;
  padding: 16px 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.timeline-controls {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}

.timeline-label {
  font-size: 14px;
  color: #666;
}

.timeline-slider {
  padding: 0 12px;
}
</style>
