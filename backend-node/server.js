const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = 8080;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// In-memory database
let ontologyTypes = [
  { id: 1, name: '公司', description: '企业法人实体', icon: 'building', color: '#1890FF' },
  { id: 2, name: '供应商', description: '供应商实体', icon: 'truck', color: '#52C41A' },
  { id: 3, name: '经销商', description: '经销商实体', icon: 'shop', color: '#FA8C16' },
  { id: 4, name: '产品', description: '产品实体', icon: 'box', color: '#722ED1' },
  { id: 5, name: '人员', description: '人员实体', icon: 'user', color: '#13C2C2' }
];

let entityInstances = [
  {
    id: 1,
    name: '海王集团股份有限公司',
    description: '海王集团',
    ontologyTypeId: 1,
    ontologyType: { id: 1, name: '公司', color: '#1890FF' },
    properties: JSON.stringify({
      '企业名称': '海王集团股份有限公司',
      '法定代表人': '张锋',
      '成立日期': '1992-12-13',
      '注册资本': '263112.3257万人民币',
      '统一社会信用代码': '914403001924440861',
      '工商注册号': '440301102909015',
      '纳税人识别号': '914403001924440861',
      '人员规模': '100-499人'
    })
  },
  {
    id: 2,
    name: '宁波海龙科技有限公司',
    description: '子公司',
    ontologyTypeId: 1,
    ontologyType: { id: 1, name: '公司', color: '#1890FF' },
    properties: JSON.stringify({
      '企业名称': '宁波海龙科技有限公司',
      '成立日期': '2015-03-20',
      '员工数': '150人',
      '所在地': '浙江省宁波市'
    })
  },
  {
    id: 3,
    name: '南京科技有限公司',
    description: '子公司',
    ontologyTypeId: 1,
    ontologyType: { id: 1, name: '公司', color: '#1890FF' },
    properties: JSON.stringify({
      '企业名称': '南京科技有限公司',
      '成立日期': '2016-08-15',
      '员工数': '200人',
      '所在地': '江苏省南京市'
    })
  },
  {
    id: 4,
    name: '供应商A',
    description: '原材料供应商',
    ontologyTypeId: 2,
    ontologyType: { id: 2, name: '供应商', color: '#52C41A' },
    properties: JSON.stringify({
      '供应商名称': '供应商A',
      '供应类型': '原材料',
      '合作年限': '5年',
      '信用等级': 'AAA'
    })
  },
  {
    id: 5,
    name: '供应商B',
    description: '设备供应商',
    ontologyTypeId: 2,
    ontologyType: { id: 2, name: '供应商', color: '#52C41A' },
    properties: JSON.stringify({
      '供应商名称': '供应商B',
      '供应类型': '设备',
      '合作年限': '3年',
      '信用等级': 'AA'
    })
  },
  {
    id: 6,
    name: '经销商A',
    description: '华东区经销商',
    ontologyTypeId: 3,
    ontologyType: { id: 3, name: '经销商', color: '#FA8C16' },
    properties: JSON.stringify({
      '经销商名称': '经销商A',
      '区域': '华东',
      '年销售额': '1000万元',
      '合作年限': '8年'
    })
  },
  {
    id: 7,
    name: '中国医药集团',
    description: '合作公司',
    ontologyTypeId: 1,
    ontologyType: { id: 1, name: '公司', color: '#1890FF' },
    properties: JSON.stringify({
      '企业名称': '中国医药集团',
      '成立日期': '2000-01-01',
      '员工数': '1000人',
      '所在地': '北京市'
    })
  },
  {
    id: 8,
    name: '阿里巴巴集团',
    description: '科技公司',
    ontologyTypeId: 1,
    ontologyType: { id: 1, name: '公司', color: '#1890FF' },
    properties: JSON.stringify({
      '企业名称': '阿里巴巴集团',
      '成立日期': '1999-09-09',
      '员工数': '10000+人',
      '所在地': '浙江省杭州市'
    })
  },
  {
    id: 9,
    name: '腾讯控股',
    description: '科技公司',
    ontologyTypeId: 1,
    ontologyType: { id: 1, name: '公司', color: '#1890FF' },
    properties: JSON.stringify({
      '企业名称': '腾讯控股',
      '成立日期': '1998-11-11',
      '员工数': '10000+人',
      '所在地': '广东省深圳市'
    })
  },
  {
    id: 10,
    name: '供应商C',
    description: '服务供应商',
    ontologyTypeId: 2,
    ontologyType: { id: 2, name: '供应商', color: '#52C41A' },
    properties: JSON.stringify({
      '供应商名称': '供应商C',
      '供应类型': '技术服务',
      '合作年限': '2年',
      '信用等级': 'A'
    })
  },
  {
    id: 11,
    name: '经销商B',
    description: '华南区经销商',
    ontologyTypeId: 3,
    ontologyType: { id: 3, name: '经销商', color: '#FA8C16' },
    properties: JSON.stringify({
      '经销商名称': '经销商B',
      '区域': '华南',
      '年销售额': '800万元',
      '合作年限': '5年'
    })
  }
];

let relationTypes = [
  { id: 1, name: '拥有', description: '所属关系', sourceTypeId: 1, targetTypeId: 1, color: '#1890FF' },
  { id: 2, name: '供应', description: '供应关系', sourceTypeId: 2, targetTypeId: 1, color: '#52C41A' },
  { id: 3, name: '销售', description: '销售关系', sourceTypeId: 1, targetTypeId: 3, color: '#FA8C16' },
  { id: 4, name: '合作', description: '合作关系', sourceTypeId: 1, targetTypeId: 1, color: '#722ED1' },
  { id: 5, name: '关联', description: '关联关系', sourceTypeId: 1, targetTypeId: 1, color: '#13C2C2' }
];

let relationships = [
  { id: 1, sourceEntityId: 1, targetEntityId: 2, relationTypeId: 1, validFrom: '2015-03-20', validTo: null },
  { id: 2, sourceEntityId: 1, targetEntityId: 3, relationTypeId: 1, validFrom: '2016-08-15', validTo: null },
  { id: 3, sourceEntityId: 4, targetEntityId: 1, relationTypeId: 2, validFrom: '2018-01-01', validTo: null },
  { id: 4, sourceEntityId: 5, targetEntityId: 1, relationTypeId: 2, validFrom: '2020-06-01', validTo: null },
  { id: 5, sourceEntityId: 1, targetEntityId: 6, relationTypeId: 3, validFrom: '2015-01-01', validTo: null },
  { id: 6, sourceEntityId: 1, targetEntityId: 7, relationTypeId: 4, validFrom: '2019-03-15', validTo: null },
  { id: 7, sourceEntityId: 10, targetEntityId: 7, relationTypeId: 2, validFrom: '2021-01-01', validTo: null }
];

let ontologyActions = [
  { id: 1, name: '查看详情', description: '查看对象详细信息', ontologyTypeId: 1, icon: '📋', actionType: 'view' },
  { id: 2, name: '编辑信息', description: '编辑对象信息', ontologyTypeId: 1, icon: '✏️', actionType: 'edit' },
  { id: 3, name: '查看报表', description: '查看相关报表', ontologyTypeId: 1, icon: '📊', actionType: 'report' },
  { id: 4, name: '添加子公司', description: '添加子公司', ontologyTypeId: 1, icon: '➕', actionType: 'add' },
  { id: 5, name: '查看供应信息', description: '查看供应详情', ontologyTypeId: 2, icon: '📦', actionType: 'view' },
  { id: 6, name: '查看销售数据', description: '查看销售统计', ontologyTypeId: 3, icon: '💰', actionType: 'view' }
];

// Helper function to get entity by id
function getEntityById(id) {
  return entityInstances.find(e => e.id === parseInt(id));
}

// Helper function to get relation type by id
function getRelationTypeById(id) {
  return relationTypes.find(r => r.id === parseInt(id));
}

// ==================== Ontology APIs ====================

// Get all ontology types
app.get('/api/ontology/types', (req, res) => {
  res.json(ontologyTypes);
});

// Get ontology type by id
app.get('/api/ontology/types/:id', (req, res) => {
  const type = ontologyTypes.find(t => t.id === parseInt(req.params.id));
  if (type) {
    res.json(type);
  } else {
    res.status(404).json({ error: 'Ontology type not found' });
  }
});

// Create ontology type
app.post('/api/ontology/types', (req, res) => {
  const newType = {
    id: ontologyTypes.length + 1,
    ...req.body
  };
  ontologyTypes.push(newType);
  res.status(201).json(newType);
});

// ==================== Graph APIs ====================

// Get graph data
app.get('/api/graph/data', (req, res) => {
  const { entityIds, timePoint } = req.query;

  let entities = entityInstances;
  let rels = relationships;

  // Filter by entity IDs if provided
  if (entityIds) {
    const ids = entityIds.split(',').map(id => parseInt(id));

    // Get all entities connected to the specified ones
    const connectedIds = new Set(ids);
    rels.forEach(rel => {
      if (ids.includes(rel.sourceEntityId) || ids.includes(rel.targetEntityId)) {
        connectedIds.add(rel.sourceEntityId);
        connectedIds.add(rel.targetEntityId);
      }
    });

    entities = entityInstances.filter(e => connectedIds.has(e.id));
    rels = relationships.filter(rel =>
      connectedIds.has(rel.sourceEntityId) && connectedIds.has(rel.targetEntityId)
    );
  }

  // Filter by time point if provided
  if (timePoint) {
    const time = new Date(timePoint);
    rels = rels.filter(rel => {
      const validFrom = new Date(rel.validFrom);
      const validTo = rel.validTo ? new Date(rel.validTo) : new Date('2099-12-31');
      return time >= validFrom && time <= validTo;
    });
  }

  // Build graph data
  const nodes = entities.map(entity => {
    const ontologyType = ontologyTypes.find(t => t.id === entity.ontologyTypeId);
    return {
      id: `entity_${entity.id}`,
      label: entity.name,
      color: ontologyType ? ontologyType.color : '#1890FF',
      ontologyTypeId: entity.ontologyTypeId,
      ontologyTypeName: ontologyType ? ontologyType.name : '',
      entityId: entity.id,
      properties: entity.properties
    };
  });

  const edges = rels.map(rel => {
    const relationType = getRelationTypeById(rel.relationTypeId);
    return {
      id: `edge_${rel.id}`,
      source: `entity_${rel.sourceEntityId}`,
      target: `entity_${rel.targetEntityId}`,
      label: relationType ? relationType.name : '',
      color: relationType ? relationType.color : '#A0A0A0',
      relationTypeId: rel.relationTypeId
    };
  });

  res.json({ nodes, edges });
});

// Peripheral search
app.post('/api/graph/peripheral-search', (req, res) => {
  const { entityIds, relationTypeIds, depth = 1, timePoint } = req.body;

  const result = new Set(entityIds);
  const visitedEdges = new Set();
  let currentLevel = new Set(entityIds);

  // BFS search
  for (let i = 0; i < depth; i++) {
    const nextLevel = new Set();

    currentLevel.forEach(entityId => {
      relationships.forEach(rel => {
        // Skip if relation type filter is set and doesn't match
        if (relationTypeIds && relationTypeIds.length > 0 && !relationTypeIds.includes(rel.relationTypeId)) {
          return;
        }

        // Check time validity
        if (timePoint) {
          const time = new Date(timePoint);
          const validFrom = new Date(rel.validFrom);
          const validTo = rel.validTo ? new Date(rel.validTo) : new Date('2099-12-31');
          if (time < validFrom || time > validTo) return;
        }

        if (rel.sourceEntityId === entityId) {
          result.add(rel.targetEntityId);
          nextLevel.add(rel.targetEntityId);
          visitedEdges.add(rel.id);
        } else if (rel.targetEntityId === entityId) {
          result.add(rel.sourceEntityId);
          nextLevel.add(rel.sourceEntityId);
          visitedEdges.add(rel.id);
        }
      });
    });

    currentLevel = nextLevel;
  }

  // Build result graph
  const entities = entityInstances.filter(e => result.has(e.id));
  const rels = relationships.filter(rel => visitedEdges.has(rel.id));

  const nodes = entities.map(entity => {
    const ontologyType = ontologyTypes.find(t => t.id === entity.ontologyTypeId);
    return {
      id: `entity_${entity.id}`,
      label: entity.name,
      color: ontologyType ? ontologyType.color : '#1890FF',
      ontologyTypeId: entity.ontologyTypeId,
      entityId: entity.id
    };
  });

  const edges = rels.map(rel => {
    const relationType = getRelationTypeById(rel.relationTypeId);
    return {
      id: `edge_${rel.id}`,
      source: `entity_${rel.sourceEntityId}`,
      target: `entity_${rel.targetEntityId}`,
      label: relationType ? relationType.name : '',
      color: relationType ? relationType.color : '#A0A0A0'
    };
  });

  res.json({ nodes, edges });
});

// Get relation types for ontology type
app.get('/api/graph/relation-types/:ontologyTypeId', (req, res) => {
  const typeId = parseInt(req.params.ontologyTypeId);
  const types = relationTypes.filter(rt =>
    rt.sourceTypeId === typeId || rt.targetTypeId === typeId
  );
  res.json(types);
});

// Get actions for ontology type
app.get('/api/graph/actions/:ontologyTypeId', (req, res) => {
  const typeId = parseInt(req.params.ontologyTypeId);
  const actions = ontologyActions.filter(a => a.ontologyTypeId === typeId);
  res.json(actions);
});

// Create entity
app.post('/api/graph/entity', (req, res) => {
  const { name, description, ontologyTypeId, properties } = req.body;

  const newEntity = {
    id: entityInstances.length + 1,
    name,
    description,
    ontologyTypeId,
    ontologyType: ontologyTypes.find(t => t.id === ontologyTypeId),
    properties: JSON.stringify(properties)
  };

  entityInstances.push(newEntity);
  res.status(201).json(newEntity);
});

// Get entities by type
app.get('/api/graph/entities/:ontologyTypeId', (req, res) => {
  const typeId = parseInt(req.params.ontologyTypeId);
  const entities = entityInstances.filter(e => e.ontologyTypeId === typeId);
  res.json(entities);
});

// Get entity by id
app.get('/api/graph/entity/:entityId', (req, res) => {
  const entity = getEntityById(req.params.entityId);
  if (entity) {
    res.json(entity);
  } else {
    res.status(404).json({ error: 'Entity not found' });
  }
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    service: 'Graph Ontology Explorer Backend'
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════════════════════════╗
║   Graph Ontology Explorer Backend - Node.js Edition       ║
╚════════════════════════════════════════════════════════════╝

🚀 Server is running on http://localhost:${PORT}

📡 Available Endpoints:
   - GET  /api/health
   - GET  /api/ontology/types
   - GET  /api/graph/data
   - POST /api/graph/peripheral-search
   - GET  /api/graph/entity/:id
   - GET  /api/graph/actions/:ontologyTypeId

📊 Database Status:
   - Ontology Types: ${ontologyTypes.length}
   - Entity Instances: ${entityInstances.length}
   - Relation Types: ${relationTypes.length}
   - Relationships: ${relationships.length}
   - Actions: ${ontologyActions.length}

✅ Ready to accept requests!
`);
});

module.exports = app;
