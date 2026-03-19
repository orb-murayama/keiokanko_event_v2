// EventHero.js - イベントヒーローセクションコンポーネント
export default {
  name: 'EventHero',
  
  props: {
    event: {
      type: Object,
      required: true
    }
  },
  
  computed: {
    heroStyle() {
      if (this.event.image_url) {
        return {
          backgroundImage: `url(${this.event.image_url})`
        };
      }
      return {
        backgroundImage: `url('https://placehold.co/1920x600/1a1a1a/ffffff?text=Event+Booking')`
      };
    }
  },
  
  template: `
    <div class="hero" :style="heroStyle">
      <div class="hero-overlay"></div>
      <div class="hero-content">
        <h1>{{ event.name || 'イベント予約システム' }}</h1>
        <p v-if="event.category">
          <i class="fas fa-tag"></i> {{ event.category }}
        </p>
      </div>
    </div>
  `
};
