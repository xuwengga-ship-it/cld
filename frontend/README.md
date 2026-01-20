# Frontend - Graph Ontology Explorer

Vue 3 frontend with AntV X6 graph visualization for the Graph Ontology Explorer system.

## Features

### Graph Visualization
- Interactive graph canvas using AntV X6
- Drag-and-drop nodes
- Multi-select with rubber band
- Zoom and pan controls
- Auto-layout with Dagre algorithm

### Peripheral Search
- Click on nodes to select
- Search connected entities by relationship type
- Configurable search depth
- Auto-layout after search

### Entity Details
- Click node to view properties
- Left panel shows detailed information
- Real-time data loading

### Timeline
- Time-series data support
- Drag slider to change time point
- Filter relationships by time
- Multiple time ranges (day, month, year)

### Actions
- Context-sensitive actions per entity type
- Configurable action menu
- Custom action handlers

### Add Entities
- Select ontology type
- Multi-select entity instances
- Add multiple entities at once
- Auto-layout after adding

## Technology Stack

- **Vue 3** - Composition API
- **AntV X6** - Graph visualization
- **Element Plus** - UI components
- **Axios** - HTTP client
- **Vue Router** - Routing
- **Vite** - Build tool

## Project Structure

```
frontend/
├── src/
│   ├── api/              # API clients
│   │   └── graph.js      # Graph and ontology APIs
│   ├── components/       # Reusable components
│   ├── views/            # Page views
│   │   └── GraphExplorer.vue  # Main graph view
│   ├── router/           # Vue router configuration
│   │   └── index.js
│   ├── utils/            # Utility functions
│   ├── assets/           # Static assets
│   ├── App.vue           # Root component
│   └── main.js           # Application entry point
├── index.html            # HTML template
├── package.json          # Dependencies
├── vite.config.js        # Vite configuration
└── README.md
```

## Setup

### Install Dependencies
```bash
npm install
```

### Development Server
```bash
npm run dev
```

Application will start at `http://localhost:3000`

### Build for Production
```bash
npm run build
```

Output will be in `dist/` directory.

### Preview Production Build
```bash
npm run preview
```

## Configuration

### Vite Configuration

Edit `vite.config.js`:

```javascript
export default defineConfig({
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
})
```

### API Base URL

Edit `src/api/graph.js` to change API base URL:

```javascript
const API_BASE_URL = '/api'
```

## Components

### GraphExplorer.vue

Main graph visualization component with all features.

**Key Methods:**
- `initGraph()` - Initialize X6 graph
- `loadGraphData()` - Load graph data from API
- `peripheralSearch()` - Execute peripheral search
- `autoLayout()` - Apply Dagre auto-layout
- `handleNodeClick()` - Handle node selection
- `addEntitiesToGraph()` - Add new entities to canvas

**Key State:**
- `selectedEntity` - Currently selected entity
- `selectedNodes` - Array of selected node IDs
- `timelineValue` - Current timeline position
- `graph` - X6 graph instance

## Graph Visualization

### AntV X6 Configuration

```javascript
const graph = new Graph({
  container: graphCanvas.value,
  panning: {
    enabled: true,
    modifiers: 'shift'
  },
  mousewheel: {
    enabled: true,
    modifiers: 'ctrl'
  },
  selecting: {
    enabled: true,
    multiple: true,
    rubberband: true
  }
})
```

### Node Configuration

```javascript
graph.addNode({
  id: node.id,
  x: node.x,
  y: node.y,
  width: 180,
  height: 60,
  shape: 'rect',
  attrs: {
    body: {
      fill: node.color,
      stroke: '#0050B3',
      rx: 6,
      ry: 6
    },
    label: {
      text: node.label,
      fill: '#fff'
    }
  }
})
```

### Edge Configuration

```javascript
graph.addEdge({
  source: edge.source,
  target: edge.target,
  attrs: {
    line: {
      stroke: edge.color,
      targetMarker: {
        name: 'block'
      }
    }
  },
  labels: [{
    attrs: {
      label: {
        text: edge.label
      }
    }
  }]
})
```

## API Integration

### Graph API Client

```javascript
import { graphApi } from '@/api/graph'

// Get graph data
const response = await graphApi.getGraphData(entityIds, timePoint)

// Peripheral search
const response = await graphApi.peripheralSearch({
  entityIds: [1, 2],
  relationTypeIds: [1],
  depth: 2
})

// Get entity details
const response = await graphApi.getEntityById(entityId)
```

### Ontology API Client

```javascript
import { ontologyApi } from '@/api/graph'

// Get all ontology types
const response = await ontologyApi.getAllOntologyTypes()

// Get entities by type
const response = await graphApi.getEntitiesByType(typeId)
```

## Styling

### CSS Variables

Key colors used in the application:

```css
--primary-color: #1890FF;
--success-color: #52C41A;
--warning-color: #FA8C16;
--error-color: #F5222D;
--background-color: #F0F2F5;
```

### Layout

- **Header**: 60px height, gradient background
- **Sidebar**: 140px width, vertical menu
- **Left Panel**: 360px width, entity details
- **Graph Canvas**: Flex 1, full remaining space
- **Timeline**: Fixed at bottom, 80% width

## Development

### Hot Module Replacement

Vite provides HMR for fast development:
- Vue component changes reload instantly
- Style changes apply without refresh
- State is preserved when possible

### Vue DevTools

Install Vue DevTools browser extension for debugging:
- Inspect component tree
- View component state
- Track events
- Monitor performance

## Building for Production

### Build
```bash
npm run build
```

### Output Structure
```
dist/
├── assets/
│   ├── index-[hash].js
│   ├── index-[hash].css
│   └── ...
└── index.html
```

### Deploy

#### Static Hosting (Nginx)

```nginx
server {
  listen 80;
  server_name example.com;
  root /var/www/ontology-explorer;
  index index.html;

  location / {
    try_files $uri $uri/ /index.html;
  }

  location /api {
    proxy_pass http://localhost:8080;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
  }
}
```

#### Docker

Create `Dockerfile`:
```dockerfile
FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## Troubleshooting

### Graph Not Rendering

**Problem**: Canvas is blank
**Solution**:
1. Check console for errors
2. Verify API connection
3. Ensure graph container has size
4. Check X6 dependencies

### API Connection Failed

**Problem**: Cannot connect to backend
**Solution**:
1. Check backend is running on port 8080
2. Verify proxy configuration in `vite.config.js`
3. Check CORS settings on backend

### Performance Issues

**Problem**: Slow rendering with many nodes
**Solution**:
1. Limit number of nodes displayed
2. Use pagination for entity lists
3. Implement virtual scrolling
4. Optimize graph layout algorithm

## Browser Support

- Chrome/Edge: Latest 2 versions
- Firefox: Latest 2 versions
- Safari: Latest 2 versions

## Dependencies

### Core
- `vue`: ^3.3.4
- `vue-router`: ^4.2.4

### Graph
- `@antv/x6`: ^2.18.1
- `@antv/layout`: ^0.3.22

### UI
- `element-plus`: ^2.4.1
- `@element-plus/icons-vue`: ^2.1.0

### HTTP
- `axios`: ^1.5.0

### Charts (Optional)
- `echarts`: ^5.4.3

## License

MIT
