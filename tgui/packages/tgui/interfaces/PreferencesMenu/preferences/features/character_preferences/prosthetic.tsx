import {
  CheckboxInput,
  FeatureChoiced,
  FeatureDropdownInput,
  FeatureToggle,
} from '../base';

export const prosthetic: FeatureChoiced = {
  name: 'Prosthetic',
  component: FeatureDropdownInput,
};

export const prosthetic_missing: FeatureToggle = {
  name: 'Prosthetic Missing',
  component: CheckboxInput,
};

export const paralysed_limb: FeatureChoiced = {
  name: 'Paralysed Limb',
  component: FeatureDropdownInput,
};
export const paralysed_limb_missing: FeatureToggle = {
  name: 'Paralysed Limb Missing',
  component: CheckboxInput,
};

export const hemiplegic_limbs_missing: FeatureToggle = {
  name: 'Hemiplegic Limbs Missing',
  component: CheckboxInput,
};

export const hemiplegic_side: FeatureChoiced = {
  name: 'Hemiplegic',
  component: FeatureDropdownInput,
};
