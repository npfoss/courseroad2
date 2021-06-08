<template>
  <!-- more on expansion panels (and more examples): https://vuetifyjs.com/en/components/expansion-panels -->
  <!-- this is the example I copied: https://v15.vuetifyjs.com/en/components/expansion-panels#expand -->
  <v-expansion-panel
    v-model="visibleList"
    expand
  >
    <!-- v-for index in N starts at 1... -->
    <!-- FYI can't use key as prop: https://stackoverflow.com/questions/47783396/access-key-from-child-component-in-vue -->
    <semester
      v-for="index in numSems"
      :key="index-1"
      :index="index-1"
      :is-open="visibleList[index-1]"
      :selected-subjects="selectedSubjects"
      :semester-subjects="selectedSubjects[index-1]"
      :road-i-d="roadID"
      :adding-from-card="addingFromCard"
      :dragging-over="dragSemesterNum===index-1"
      :hide-iap="hideIAP"
      @open-road-settings-dialog="openRoadSettings = true"
    />
    <v-dialog v-model="openRoadSettings" max-width="600">
      <v-card>
        <v-btn icon flat style="float:right" @click="openRoadSettings = false">
          <v-icon>close</v-icon>
        </v-btn>
        <v-card-title>
          <h1>Road Settings</h1>
        </v-card-title>
        <v-card-text>
          <v-select
            id="year-choices"
            v-model="year"
            :items="[{value: 0,text:'First Year/Freshman'},{value: 1,text:'Sophomore'},{value:2,text:'Junior'},{value:3,text:'Senior'},{value:4,text:'Super Senior'}]"
            label="I am a..."
            outlined
            data-cy="selectClassYear"
          />
          <v-switch
            v-model="hideIAP"
            label="Hide IAP"
          />
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn flat @click="openRoadSettings = false">
            Cancel
          </v-btn>
          <v-btn id="change-year" color="primary" data-cy="submitRoadSettingsButton" @click="$emit('change-year',year); openRoadSettings = false;">
            Submit
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-expansion-panel>
</template>

<script>
import Semester from './Semester.vue';

export default {
  created () {
    this.$root.$refs.Road = this;
  },
  name: 'Semester',
  components: {
    'semester': Semester
  },
  props: {
    selectedSubjects: {
      type: Array,
      required: true
    },
    roadID: {
      type: String,
      required: true
    },
    addingFromCard: {
      type: Boolean,
      required: true
    },
    dragSemesterNum: {
      type: Number,
      required: true
    }
  },
  data: function () {
    const defaultOpen = [false, true, false, true, true, false, true, true, false, true, true, false, true];
    const numSemesters = 16;
    return {
      visibleList: numSemesters >= 13 ? defaultOpen.concat([true, false, true]) : defaultOpen,
      openRoadSettings: false,
      numSems: numSemesters
    };
  },
  computed: {
    year: {
      get: function () {
        return this.$store.getters.userYear;
      },
      set: function (newYear) {
        this.$emit('change-year', newYear);
      }
    },
    hideIAP: {
      get: function () {
        return this.$store.getters.hideIAP;
      },
      set: function (value) {
        this.$store.commit('setHideIAP', value);
      }
    }
  },
  watch: {
    visibleList: function (newVisibleList) {
      if (this.$store.state.cookiesAllowed) {
        this.$cookies.set('visibleList' + this.roadID, JSON.stringify(newVisibleList));
      }
    }
  },
  methods: {
    all: function () {
      this.visibleList = [...Array(this.numSems).keys()].map(_ => false);
    },
    none: function () {
      this.visibleList = [...Array(this.numSems).keys()].map(_ => true);
    }
  },
  mounted () {
    const visibleList = JSON.parse(this.$cookies.get('visibleList' + this.roadID));
    if (this.$store.state.cookiesAllowed && visibleList) {
      if (Array.isArray(visibleList) && visibleList.length === this.numSems) {
        this.visibleList = visibleList;
      } else {
        this.$cookies.remove('visibleList' + this.roadID);
      }
    };
  }
};
</script>
